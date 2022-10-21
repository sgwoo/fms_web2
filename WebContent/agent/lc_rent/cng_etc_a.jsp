<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body>
<%
//	if(1==1)return;
	

	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
%>


<%
		//계약기본정보-----------------------------------------------------------------------------------------------
		
		//cont
		ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		base.setOthers			(request.getParameter("others")	==null?"":request.getParameter("others"));
		//=====[cont] update=====
		flag1 = a_db.updateContBaseNew(base);
		
		
		//계약기타정보-----------------------------------------------------------------------------------------------
		
		//cont_etc
		ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
		cont_etc.setDec_etc		(request.getParameter("dec_etc")==null?"":request.getParameter("dec_etc"));
		cont_etc.setCls_etc	(request.getParameter("cls_etc")		==null?"":request.getParameter("cls_etc"));
		if(cont_etc.getRent_mng_id().equals("")){
			//=====[cont_etc] insert=====
			cont_etc.setRent_mng_id	(rent_mng_id);
			cont_etc.setRent_l_cd	(rent_l_cd);
			flag2 = a_db.insertContEtc(cont_etc);
		}else{
			//=====[cont_etc] update=====
			flag2 = a_db.updateContEtc(cont_etc);
		}
		
		
		//차량기본정보-----------------------------------------------------------------------------------------------
		
		//car_etc
		ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		car.setRemark		(request.getParameter("remark")			==null?"":request.getParameter("remark"));
		//=====[car_etc] update=====
		flag3 = a_db.updateContCarNew(car);
		
		
		//대여정보-----------------------------------------------------------------------------------------------
		
		for(int i=1; i<=fee_size; i++){
			//fee
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i));
			fees.setFee_cdt			(request.getParameter("fee_cdt"+i)		==null?"":request.getParameter("fee_cdt"+i));
			//=====[fee] update=====
			flag4 = a_db.updateContFeeNew(fees);
			
			//fee_etc
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(i));
			fee_etcs.setBc_etc			(request.getParameter("bc_etc"+i)			==null?"":request.getParameter("bc_etc"+i));
			
			
			
			if(fee_etcs.getRent_st().equals("1")){
			
				fee_etcs.setBus_cau	(request.getParameter("bus_cau")==null?"":request.getParameter("bus_cau"));
		
				if(fee_etcs.getBus_cau().equals("")){
					fee_etcs.setBus_yn	("N");
				}else{
					fee_etcs.setBus_yn	("Y");	
				}
		
				//=====[fee_etc] update=====
				flag6 = a_db.updateFeeEtcBus(fee_etcs);			
			}			
		}
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag2){	%>	alert('계약기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag3){	%>	alert('차량기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag4){	%>	alert('대여기본정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
<%		if(!flag5){	%>	alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');	<%		}	%>		
</script>



<form name='form1' method='post'>
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
  <input type="hidden" name="rent_st" 			value="">
</form>
<script language='javascript'>

	var fm = document.form1;
	
	if('<%=from_page%>' == '/agent/lc_rent/lc_bc_frame.jsp'){
		fm.rent_st.value = '<%=request.getParameter("rent_st")==null?"1":request.getParameter("rent_st")%>';
		fm.action = '/agent/lc_rent/lc_bc_u.jsp';	
		fm.target = 'd_content';
		fm.submit();
	}else{
		fm.action = '<%=from_page%>';	
		fm.target = 'c_foot';
		fm.submit();
	}
	
	parent.window.close();
//	window.close();

</script>
</body>
</html>