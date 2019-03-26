        function [aoVolts,pathFOV] = calcStreamingBuffer(obj, bufStartFrm, nFrames)
            bufEndFrm = (bufStartFrm+nFrames-1);

            if obj.aoSlices > 1
                % the generated AO is for multiple slices. for each frame we
                % need to extract the correct slice from the correct buffer
                frms = bufStartFrm:(bufStartFrm+nFrames-1);
                for ifr = numel(frms):-1:1
                    ss = 1 + (ifr-1)*obj.frameSamps;
                    es = ifr*obj.frameSamps;
                    
                    slcInd = mod(frms(ifr)-1,obj.aoSlices)+1;
                    aoSs = 1 + (slcInd-1)*obj.frameSamps;
                    aoEs = slcInd*obj.frameSamps;
                    
                    if (frms(ifr) >= obj.powerBoxStartFrame) && (frms(ifr) <= obj.powerBoxEndFrame) && obj.hasPowerBoxes
                        aoVolts(ss:es,:) = obj.hSI.hWaveformManager.scannerAO.ao_volts.Bpb(aoSs:aoEs,:);
                        pathFOV(ss:es,:) = obj.hSI.hWaveformManager.scannerAO.pathFOV.Bpb(aoSs:aoEs,:);
                    else
                        aoVolts(ss:es,:) = obj.hSI.hWaveformManager.scannerAO.ao_volts.B(aoSs:aoEs,:);
                        pathFOV(ss:es,:) = obj.hSI.hWaveformManager.scannerAO.pathFOV.B(aoSs:aoEs,:);
                    end
                end
            else
                if (bufStartFrm >= obj.powerBoxStartFrame) && (bufEndFrm <= obj.powerBoxEndFrame) && obj.hasPowerBoxes
                    % power box is on the whole time
                    aoVolts = repmat(obj.hSI.hWaveformManager.scannerAO.ao_volts.Bpb, nFrames, 1);
                    pathFOV = repmat(obj.hSI.hWaveformManager.scannerAO.pathFOV.Bpb,  nFrames, 1);
                else
                    aoVolts = repmat(obj.hSI.hWaveformManager.scannerAO.ao_volts.B, nFrames, 1);
                    pathFOV = repmat(obj.hSI.hWaveformManager.scannerAO.pathFOV.B, nFrames, 1);
                    if (bufStartFrm <= obj.powerBoxEndFrame) && (bufEndFrm >= obj.powerBoxStartFrame) && obj.hasPowerBoxes
                        % power box is on at lease some of the time
                        onStartFr = max(bufStartFrm, obj.powerBoxStartFrame);
                        onEndFr = min(bufEndFrm, obj.powerBoxEndFrame);
                        ss = (onStartFr-bufStartFrm)*length(obj.hSI.hWaveformManager.scannerAO.ao_volts.B) + 1;
                        se = (onEndFr-bufStartFrm+1)*length(obj.hSI.hWaveformManager.scannerAO.ao_volts.B);
                        aoVolts(ss:se,:) = repmat(obj.hSI.hWaveformManager.scannerAO.ao_volts.Bpb, onEndFr-onStartFr+1, 1);
                        pathFOV(ss:se,:) = repmat(obj.hSI.hWaveformManager.scannerAO.pathFOV.Bpb, onEndFr-onStartFr+1, 1);
                    end
                end
                
                % Check for OertnerLabSpecials:Alternating Beam Scanning!
                if ~strcmp(obj.hSI.acqState, 'focus')
                    try
                        OLS = evalin('base', 'OLS');
                        % Great, OertnerLabSpecials GUI is running!
                        % We do not check if obj.hSI.framesPerAcq==2!
                        if OLS.abs.absSwitch && ~mod(nFrames, 2)
                            powerFracs = [0, 0; OLS.abs.pwr(1)/100, OLS.abs.pwr(2)/100];
                            voltages = obj.zprpBeamsPowerFractionToVoltage([1, 2], powerFracs);
                            
                            template = obj.hSI.hWaveformManager.scannerAO.pathFOV.B;
                            mm = [min(template); max(template)];
                            frm1_b1on = (template(:, 1) == mm(2, 1));
                            frm2_b2on = (template(:, 2) == mm(2, 2));
                            
                            fov_frm1 = obj.hSI.hWaveformManager.scannerAO.pathFOV.B;
                            fov_frm1(:, 2) = 0;
                            fov_frm2 = obj.hSI.hWaveformManager.scannerAO.pathFOV.B;
                            fov_frm2(:, 1) = 0;
                            pathFOV = repmat([fov_frm1; fov_frm2], (nFrames/2), 1);
                            
                            volts_frm1 = zeros(size(template)) + voltages(1,:);
                            volts_frm1(frm1_b1on, 1) = voltages(2, 1);
                            volts_frm2 = zeros(size(template)) + voltages(1,:);
                            volts_frm2(frm2_b2on, 2) = voltages(2, 2);
                            aoVolts = repmat([volts_frm1; volts_frm2], (nFrames/2), 1);                            
                        end
                    catch
                        % That's just fine!
                    end
                end
            end
        end
        
