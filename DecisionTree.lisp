(defun splitBySpace(str) "This function is to split a line of string read from file by space."
  (setf str (concatenate 'string str " ") resultStr nil)
  (labels ((split(str)(
    when (setq pos (position #\  str)) 
      (when (/= (length (setq sub (subseq str 0 pos))) 0)
         (setf resultStr (append resultStr (list sub))))
      (split (subseq str (+ pos 1) (length str))))
  )) (split str))
  (list resultStr))
(defun entropy (dataList) "This function is to compute the entropy of the  dataList"
  (let ((colLen (length (car dataList)))
        (rowLen (length dataList))
        (rateList nil)
        (result 0))
  (setq rateList(getRates dataList (- colLen 1)));;get the proportion
  (loop for tuple in rateList
    do(setq result (- result (* (float (/ (second tuple) rowLen)) (log (float (/ (second tuple) rowLen)) 2))))) 
  result))

(defun getRates(dataList pos) "This function is to computer the proportion of each value of an attr"
  (let ((rateList nil)(flag 0))
    (loop for x in dataList do
      (setq flag 0)
        (loop for tuple in rateList do
          (when (equal (nth pos x) (car tuple))
            (setf (second tuple) (+ (second tuple) 1))
            (return (setq flag 1))))
        (when (= flag 0)
          (setf rateList (append rateList (list(list (nth pos x) 1))))))
  rateList))

(defun tree (list) "this funtion is to generate the decision tree recursively"
  (let* ((dataList (subseq list 1 (length list)))
          (attrList (car list))
          (colLen (length attrList))
          (rowLen (length dataList))
          (rateList nil)
          (tempTree 0)
          (optimalGain -1)
          (temp 0)
          (gainList 0)
          (optimalGainAttrs nil)
          (finalTree nil)
          (selCol 0))
    (loop for col from 0 to (- colLen 2) do
      (setf gainList  (getGain dataList col (entropy dataList) rowLen colLen))
      (when (> (setq temp (car gainList)) optimalGain)
        (setq optimalGain temp selCol col)
        (setf optimalGainAttrs (second gainList))))
    (loop for tuple in optimalGainAttrs do
      (setf (car tuple) (concatenate 'string (concatenate 'string (nth selCol attrList) " ") (car tuple)))
        (when (not (second tuple))
          (setf tempTree (tree (cutColnmn list selCol (second(car (splitBySpace (car tuple)))))))
          (setf (second tuple) (car tempTree))
          (loop for i from 1 to (- (length tempTree) 1) do
            (setf tuple (append tuple  (list (nth i tempTree))))))   
        (setf finalTree (append finalTree (list tuple)))) ;;format the result by the given format.
   finalTree))

(defun cutColnmn(list col attr) "this function is to get the sublist after choosing some attrs"
  (let ((resultList nil))
    (loop for row in list do
      (when (or (equal attr (nth col row)) (equal (nth col (car list)) (nth col row)))
        (setf resultList 
          (append resultList (list (append (subseq row 0 col) (subseq row (+ 1 col) (length row))))))))
      resultList))

(defun getGain(dataList col entropyValue rowLen colLen)"this function is to get the gain when some attrs have been chosen"
    (let((gain entropyValue)
         (rateList (getRates dataList col))
         (subList nil)
         (times 0)
         (subEntropyValue 0)
         (isFinalList nil)
         (decision nil))
    (loop for tuple in rateList 
      do(setf subList nil times 0 decision nil)
        (loop for row in dataList
          do(when(equal (car tuple) (nth col row))
            (setf subList (append subList (list (list (car tuple) (nth (- colLen 1) row)))))
                    (setq times (+ 1 times))))
        (setq subEntropyValue (entropy subList))
        (setq gain (- gain (* (float (/ times rowLen)) subEntropyValue)))
        (if  (= subEntropyValue 0)
          (setq decision (second (car subList))))
          (setf isFinalList (append isFinalList (list(list (car tuple) decision)))))
    (list gain isFinalList)))

(defun main (fileName) "this is the entry function"
  (setq protoList nil)
  (setq text (open fileName))
  (loop for line = (read-line text nil);;read the file 
      while line do 
        (when (car (setq lineAfterSplit (splitBySpace line)))
              (setf protoList (append protoList lineAfterSplit))))
   (princ (tree protoList)))

(main "data.txt")