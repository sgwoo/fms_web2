<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.con_tax.*, acar.util.*, acar.cont.*, acar.res_search.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%

	String idx[] 			= request.getParameterValues("ch_l_cd");
	String tax_st[] 		= request.getParameterValues("tax_st");
	String rent_mng_id[] 	= request.getParameterValues("rent_mng_id");
	String rent_l_cd[] 		= request.getParameterValues("rent_l_cd");
	String car_mng_id[]		= request.getParameterValues("car_mng_id");
	String tax_come_dt[] 	= request.getParameterValues("tax_come_dt");
	String car_fs_amt[] 	= request.getParameterValues("car_fs_amt");
	
	String sur_rate[] 		= request.getParameterValues("sur_rate");
	String sur_amt[] 		= request.getParameterValues("sur_amt");
	String tax_rate[] 		= request.getParameterValues("tax_rate");
	String spe_tax_amt[] 	= request.getParameterValues("spe_tax_amt");
	String edu_tax_amt[] 	= request.getParameterValues("edu_tax_amt");
	String tax_amt[] 		= request.getParameterValues("tax_amt");
	
	boolean flag = true;
	
	int idx_size = idx.length;
	int idx_num = 0;
	
	out.println("선택건수="+idx_size+"<br><br>");
	
	for(int i=0;i < idx_size;i++){
		
		flag = true;
		
		idx_num 	= Util.parseInt(idx[i]);
		
		
		String m_id = rent_mng_id[idx_num];
		String l_cd = rent_l_cd[idx_num];
		
		//계약정보
		Hashtable cont = t_db.getAllotByCase(m_id, l_cd);
		//기타정보
		Hashtable tax = t_db.getTaxScdInfo(m_id, l_cd);
		
		
		TaxScdBean bean = new TaxScdBean();
	    bean.setRent_mng_id	(m_id);
	    bean.setRent_l_cd	(l_cd);
		bean.setCar_mng_id	(car_mng_id[idx_num]);
	    bean.setSur_rate	(sur_rate[idx_num]);
    	bean.setSur_amt		(sur_amt[idx_num]==null?0:Util.parseDigit(sur_amt[idx_num]));
	    bean.setTax_rate	(tax_rate[idx_num]);
    	bean.setSpe_tax_amt	(spe_tax_amt[idx_num]==null?0:Util.parseDigit(spe_tax_amt[idx_num]));
	    bean.setEdu_tax_amt	(edu_tax_amt[idx_num]==null?0:Util.parseDigit(edu_tax_amt[idx_num]));
    	bean.setPay_amt		(tax_amt[idx_num]==null?0:Util.parseDigit(tax_amt[idx_num]));
		if(tax_st[idx_num].equals("장기대여")){
	    	bean.setTax_st		("1");
		}else if(tax_st[idx_num].equals("용도변경")){
	    	bean.setTax_st		("3");
		}else if(tax_st[idx_num].equals("매각")){
	    	bean.setTax_st		("2");
    		bean.setCls_man_st	("0");//일반인
		}else if(tax_st[idx_num].equals("폐차")){
	    	bean.setTax_st		("4");
		}
	    bean.setTax_apply	("2");//경과연수별 잔존가치율
    	bean.setTax_come_dt	(tax_come_dt[idx_num]==null?"":tax_come_dt[idx_num]);
    	bean.setCar_fs_amt	(car_fs_amt[idx_num]==null?0:Util.parseDigit(car_fs_amt[idx_num]));
		
		String est_dt = rs_db.addMonth(tax_come_dt[idx_num], 1);
		String est_max_day = "31";
		if(est_dt.length()==8){
			est_max_day = String.valueOf(AddUtil.getMonthDate(AddUtil.parseInt(est_dt.substring(0,4)), AddUtil.parseInt(est_dt.substring(4,6))));
			est_dt = est_dt.substring(0,6)+""+est_max_day;
		}
		out.println("tax_come_dt[idx_num]="+tax_come_dt[idx_num]+"<br><br>");
		out.println("est_dt="+est_dt+"<br><br>");
		out.println("est_max_day="+est_max_day+"<br><br>");
		
    	bean.setEst_dt		(est_dt);
		bean.setReg_id		(ck_acar_id);
		
		String pay_mon = "";
		if(est_dt.equals("20100131")) pay_mon = "201004";
		if(est_dt.equals("20100228")) pay_mon = "201004";
		if(est_dt.equals("20100331")) pay_mon = "201004";
		if(est_dt.equals("20100430")) pay_mon = "201007";
		if(est_dt.equals("20100531")) pay_mon = "201007";
		if(est_dt.equals("20100630")) pay_mon = "201007";
		if(est_dt.equals("20100731")) pay_mon = "201010";
		if(est_dt.equals("20100831")) pay_mon = "201010";
		if(est_dt.equals("20100930")) pay_mon = "201010";
		if(est_dt.equals("20101031")) pay_mon = "201101";
		if(est_dt.equals("20101130")) pay_mon = "201101";
		if(est_dt.equals("20101231")) pay_mon = "201101";
		
		if(est_dt.equals("20110131")) pay_mon = "201104";
		if(est_dt.equals("20110228")) pay_mon = "201104";
		if(est_dt.equals("20110331")) pay_mon = "201104";
		if(est_dt.equals("20110430")) pay_mon = "201107";
		if(est_dt.equals("20110531")) pay_mon = "201107";
		if(est_dt.equals("20110630")) pay_mon = "201107";
		if(est_dt.equals("20110731")) pay_mon = "201110";
		if(est_dt.equals("20110831")) pay_mon = "201110";
		if(est_dt.equals("20110930")) pay_mon = "201110";
		if(est_dt.equals("20111031")) pay_mon = "201201";
		if(est_dt.equals("20111130")) pay_mon = "201201";
		if(est_dt.equals("20111231")) pay_mon = "201201";
		
		if(est_dt.equals("20120131")) pay_mon = "201204";
		if(est_dt.equals("20120229")) pay_mon = "201204";
		if(est_dt.equals("20120331")) pay_mon = "201204";
		if(est_dt.equals("20120430")) pay_mon = "201207";
		if(est_dt.equals("20120531")) pay_mon = "201207";
		if(est_dt.equals("20120630")) pay_mon = "201207";
		if(est_dt.equals("20120731")) pay_mon = "201210";
		if(est_dt.equals("20120831")) pay_mon = "201210";
		if(est_dt.equals("20120930")) pay_mon = "201210";
		if(est_dt.equals("20121031")) pay_mon = "201301";
		if(est_dt.equals("20121130")) pay_mon = "201301";
		if(est_dt.equals("20121231")) pay_mon = "201301";
		
		pay_mon = pay_mon+"25";
		bean.setEst_dt2		(pay_mon);
		
		
		flag = t_db.insertTax(bean);
	}
%>
<form action="" name="form1" method="POST">
</form>

<script language='javascript'>
<!--
<%	if(!flag){%>
		alert('에러입니다.');
		location='about:blank';
<%	}else{%>		
		alert('등록되었습니다');
		parent.location.reload();
<%	}%>
//-->
</script>
</body>
</html>
