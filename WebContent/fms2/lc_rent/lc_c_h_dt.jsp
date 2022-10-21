<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_register.*, acar.car_office.*"%>
<%@ page import="acar.cls.*, acar.offls_sui.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	CarRegDatabase crd = CarRegDatabase.getInstance();


	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);	
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	

	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");

	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
		
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//차량회수일
	String reco_dt =  ac_db.getClsRecoDt(rent_mng_id, rent_l_cd);	
	reco_dt 	= reco_dt==null?"":reco_dt;	

	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
			
	//매각정보
	SuiBean sBean = olsD.getSui(base.getCar_mng_id());
	
	//중고차 딜러와 판매처	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "6");
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="change_item"	value="">    
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
		    <table border="0" cellspacing="1" cellpadding='0' width=100%>
		  		<tr>
				  <td width='42%' class=title>계약일자</td>
				  <td width='58%'>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('cont')"><%=AddUtil.ChangeDate2(base.getRent_dt())%></a></td>
		  		</tr>
		  		<%if(base.getCar_gu().equals("2")){%>
		  		<tr>
				  <td class=title>매매일자</td>
				  <td>&nbsp;<%=AddUtil.ChangeDate2(emp2.getSh_base_dt())%></td>
		  		</tr>
		  		<tr>
				  <td class=title>등록일자</td>
				  <td>&nbsp;<%=AddUtil.ChangeDate2(car.getSh_init_reg_dt())%></td>
		  		</tr>
		  		<%}else{%>
		  		<tr>
				  <td class=title>출고<%if(base.getDlv_dt().equals("")){%>예정<%}%>일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('pur')"><%=AddUtil.ChangeDate2(base.getDlv_dt())%><%if(base.getDlv_dt().equals("")){%><%=AddUtil.ChangeDate2(pur.getDlv_est_dt())%><%}%></a></td>
		  		</tr>
		  		<tr>
				  <td class=title>등록일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('car')"><%=AddUtil.ChangeDate2(cr_bean.getInit_reg_dt())%></a></td>
		  		</tr>
		  		<%}%>
				  <%if(!base.getCar_st().equals("2")){%>
				  <%if(fee.getPrv_dlv_yn().equals("Y")){%>
		  		<tr>
				  <td class=title>지연대차개시일</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('taecha')"><%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></a></td>
		  		</tr>					
		  		<tr>
				  <td class=title>지연대차만료일</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('taecha')"><%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></a></td>
		  		</tr>					
				  <%}%>
		  		<tr>
				  <td class=title>차량인도일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('fee1')"><%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></a>
				    <%if(base.getCar_gu().equals("0") && cont_etc.getCar_deli_dt().equals("") && !cont_etc.getCar_deli_est_dt().equals("")){%>
				    (인도예정일:<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>)
				    <%} %>
				  </td>
		  		</tr>				
				  <%for(int i=0; i<fee_size; i++){
					ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
					if(!ext_fee.getCon_mon().equals("")){%>	
					<%if(i>0){%>
		  		<tr>
				  <td class=title><%if(i>0){%>연장<%}%>계약일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('fee<%=i+1%>')"><%=AddUtil.ChangeDate2(ext_fee.getRent_dt())%></a></td>
		  		</tr>
					<%}%>
		  		<tr>
				  <td class=title><%if(i>0){%>연장<%}%>대여개시일</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('fee<%=i+1%>')"><%=AddUtil.ChangeDate2(ext_fee.getRent_start_dt())%></a></td>
		  		</tr>
		  		<tr>
				  <td class=title><%if(i>0){%>연장<%}%>만료예정일</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('fee<%=i+1%>')"><%=AddUtil.ChangeDate2(ext_fee.getRent_end_dt())%></a></td>
		  		</tr>					
				<%}}%>	
		  		<tr>
				  <td class=title>차량반납일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('cls')"><%=AddUtil.ChangeDate2(reco_dt)%></a></td>
		  		</tr>								
				<%if(base.getUse_yn().equals("N")){%>
		  		<tr>
				  <td class=title><%if(cls.getCls_st().equals("계약만료") || cls.getCls_st().equals("매입옵션") || cls.getCls_st().equals("매각") || cls.getCls_st().equals("중도해약") || cls.getCls_st().equals("출고전해지") || cls.getCls_st().equals("개시전해지")){%>계약해지일<%}else{%>계약변경일<%}%></td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('cls')"><%=AddUtil.ChangeDate2(cls.getCls_dt())%></a></td>
		  		</tr>
				<%	if(cls.getCls_st().equals("매입옵션") || cls.getCls_st().equals("매각")){%>
		  		<tr>
				  <td class=title>매매일자</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('cls')"><%=AddUtil.ChangeDate2(sBean.getCont_dt())%></a></td>
		  		</tr>				
		  		<tr>
				  <td class=title>명의이전일</td>
				  <td>&nbsp;<a href="#" onClick="javascript:parent.display_h_in('cls')"><%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></a></td>
		  		</tr>				
				<%	}%>
				<%}%>
				<%}%>
		    </table>
	    </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
