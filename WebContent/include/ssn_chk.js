/* 주민등록번호 검사 & 전화번호 폼 체크*/

	//주민/사업자등록번호 검사하기
	function ssn_chk1(str){
		var num = replaceString('-', '', str);
		if(num.length == 13){//주민등록번호
		    if(IsMon(num.substr(2,2)) && IsDay(num.substr(4,2))){
				if(num.substr(6,1) > 0 && num.substr(6,1) < 5){
					return true;
				}
			}
			return false;
		}else if(num.length == 10){//사업자등록번호		
			var sumMod = 0;
	        sumMod += parseInt(num.substring(0,1));
    	    sumMod += parseInt(num.substring(1,2)) * 3 % 10;
	        sumMod += parseInt(num.substring(2,3)) * 7 % 10;
    	    sumMod += parseInt(num.substring(3,4)) * 1 % 10;
        	sumMod += parseInt(num.substring(4,5)) * 3 % 10;
	        sumMod += parseInt(num.substring(5,6)) * 7 % 10;
    	    sumMod += parseInt(num.substring(6,7)) * 1 % 10;
        	sumMod += parseInt(num.substring(7,8)) * 3 % 10;
	        sumMod += Math.floor(parseInt(num.substring(8,9)) * 5 / 10);
    	    sumMod += parseInt(num.substring(8,9)) * 5 % 10;
        	sumMod += parseInt(num.substring(9,10));        
       	 	if(sumMod % 10 != 0){
                return false;
        	}
        	return true;
		}
	}
	function IsMon(num){
	  	if(num < 1 || num > 12){
			return false;
      	}
      	return true;   
   	}
   	function IsDay(num) {
	  	if(num < 1 || num > 31) {
         	return false;
      	}
      	return true;   
   	}	
	function formCheck(ssn){
		var theForm = document.form1;
        errfound = false;
        var str_jumin1 = ssn.substring(0,6);
        var str_jumin2 = ssn.substring(6,13);
        var checkImg='';
		
        var i3=0
        for(var i=0;i<str_jumin1.length;i++){
        	var ch1 = str_jumin1.substring(i,i+1);
            if(ch1<'0' || ch1>'9') { i3=i3+1 }
        }
        if((str_jumin1 == '') || ( i3 != 0 )){	error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!');	}
		
		var i4=0
        for(var i=0;i<str_jumin2.length;i++){
        	var ch1 = str_jumin2.substring(i,i+1);
            if(ch1<'0' || ch1>'9') { i4=i4+1 }
        }
        if((str_jumin2 == '') || ( i4 != 0 )){ 	error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
        if(str_jumin1.substring(0,1) < 4){ 		error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
        if(str_jumin2.substring(0,1) > 2){ 		error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
        if((str_jumin1.length > 7) || (str_jumin2.length > 8)){ error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
        if((str_jumin1 == '72') || ( str_jumin2 == '18')){ 		error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
                
		var f1=str_jumin1.substring(0,1)
		var f2=str_jumin1.substring(1,2)
		var f3=str_jumin1.substring(2,3)
		var f4=str_jumin1.substring(3,4)
		var f5=str_jumin1.substring(4,5)
		var f6=str_jumin1.substring(5,6)
		var hap=f1*2+f2*3+f3*4+f4*5+f5*6+f6*7
		var l1=str_jumin2.substring(0,1)
		var l2=str_jumin2.substring(1,2)
		var l3=str_jumin2.substring(2,3)
		var l4=str_jumin2.substring(3,4)
		var l5=str_jumin2.substring(4,5)
		var l6=str_jumin2.substring(5,6)
		var l7=str_jumin2.substring(6,7)
		hap=hap+l1*8+l2*9+l3*2+l4*3+l5*4+l6*5
		hap=hap%11
		hap=11-hap
		hap=hap%10
		if(hap != l7){ error(theForm.est_ssn,'없는 주민등록번호 입니다.\n\n다시 입력해 주세요!!'); }
		var i9=0
	}
	function error (elem,text) {
        if (errfound) return;
        window.alert(text);
        elem.select();
        elem.focus();
        errfound=true;
	}
	
	//휴대전화 세팅
	function SetMTel(){
		var fm = document.form1;	
		var tel = replaceString('-', '', fm.res_m_tel.value);		
		var tel_len = tel.length;
		if(tel_len > 3){
			var tel_h = tel.substring(0,3);
			if(tel_h=='010'||tel_h=='011'||tel_h=='016'||tel_h=='017'||tel_h=='018'||tel_h=='019'){//핸드폰
				if(tel_len == 10){
					fm.res_m_tel.value = tel.substring(0,3)+"-"+tel.substring(3,6)+"-"+tel.substring(6,10);				
				}else if(tel_len == 11){
					fm.res_m_tel.value = tel.substring(0,3)+"-"+tel.substring(3,7)+"-"+tel.substring(7,11);								
				}				
			}else{
				if(tel_h.substring(0,2) == '02'){//서울
					if(tel_len == 9){
						fm.res_m_tel.value = tel.substring(0,2)+"-"+tel.substring(2,5)+"-"+tel.substring(5,9);				
					}else if(tel_len == 10){
						fm.res_m_tel.value = tel.substring(0,2)+"-"+tel.substring(2,6)+"-"+tel.substring(6,10);								
					}							
				}else{//지방
					if(tel_len == 10){
						fm.res_m_tel.value = tel.substring(0,3)+"-"+tel.substring(3,6)+"-"+tel.substring(6,10);				
					}else if(tel_len == 11){
						fm.res_m_tel.value = tel.substring(0,3)+"-"+tel.substring(3,7)+"-"+tel.substring(7,11);								
					}					
				}
			}
		}
	}				
	
