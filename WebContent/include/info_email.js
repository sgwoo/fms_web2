function OpenAmazonCAR(arg){
	if(arg=='1'){
	   	var fm = document.form1;
	   	if(fm.var3.value == '1') 	fm.action = '/fms2/lc_rent/lc_c_h_confirm_template.jsp';
	   	if(fm.var3.value == '2') 	fm.action = '/fms2/lc_rent/lc_c_h_confirm_template.jsp';
	   	if(fm.var3.value == '3') 	fm.action = '/fms2/lc_rent/lc_b_s_reqdoc.jsp';
	   	if(fm.var3.value == '4') 	fm.action = '/fms2/lc_rent/lc_c_h_confirm_template2.jsp';
	   	if(fm.var3.value == '5') 	fm.action = '/acar/ins_mng/ins_u_sh_emp_print.jsp';
	   	if(fm.var3.value == '6') 	fm.action = '/fms2/lc_rent/lc_c_h_confirm_template3.jsp';
	   	if(fm.var3.value == '7') 	fm.action = '/fms2/lc_rent/lc_c_h_confirm_template4.jsp';
	   	fm.submit();
	}else if(arg=='2'){
		alert('error');
		return;
	}	
}
