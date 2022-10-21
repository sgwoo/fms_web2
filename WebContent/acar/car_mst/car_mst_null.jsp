<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.common.*,  acar.estimate_mng.*" %>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase a_cdb = AddCarMstDatabase.getInstance();
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CommonDataBase 	  c_db  = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String sel 			= request.getParameter("sel")			==null?"":request.getParameter("sel");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")			==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")		==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")		==null?"":request.getParameter("view_dt");
	String mode 		= request.getParameter("mode")			==null?"":request.getParameter("mode");
	String rent_way 	= request.getParameter("rent_way")		==null?"":request.getParameter("rent_way");
	String a_a 			= request.getParameter("a_a")			==null?"":request.getParameter("a_a");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")			==null?"":request.getParameter("asc");
	String gubun1 		= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String from_page	= request.getParameter("from_page")		==null?"":request.getParameter("from_page");
	
	int count = 0;
	int car_size = 0;
	CommonEtcBean addCarAmts[] = null;
	Vector cars = null;
	
	if(mode.equals("opt")){
		addCarAmts = c_db.getCommonEtcAll("add_car_amt","car_code",code,"","","","","","");
	}else{
		cars = a_cdb.getSearchCode(car_comp_id, code, car_id, view_dt, mode, a_a, gubun1, sort_gubun, asc);
		car_size = cars.size();
	}
	int indexV = 0;
	
	int car_size2 = 0;
	if(mode.equals("1") && from_page.equals("/acar/car_mst/car_mst_sh.jsp")){
		CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id);
		for(int i=0; i<cm_r.length; i++){
			CarMstBean cm_bean = cm_r[i];
			if(cm_bean.getCar_yn().equals("N")){
				car_size2++;
			}
		}	
	}	
	
	//차종코드별변수 
	Vector jgVarList = new Vector();
	int jgVarList_size = 0;
	
	if(mode.equals("opt") && from_page.equals("/acar/car_mst/car_mst_i.jsp")){
		
		out.println("차종코드 선택");
		out.println("car_comp_id="+car_comp_id+"_");
		out.println("code="+code+"_");
		
		jgVarList = e_db.getEstiJgVarCarList(cmb.getCarAbNm(car_comp_id, code));
		jgVarList_size = jgVarList.size();
		
		if(ck_acar_id.equals("000029") || ck_acar_id.equals("000311") || ck_acar_id.equals("000312")){
			jgVarList = e_db.getEstiJgVarCarAllList(cmb.getCarAbNm(car_comp_id, code));
			jgVarList_size = jgVarList.size();
		}
			
		
		//차명으로 가져오는 게 없으면 전체리스트
		if(jgVarList_size==0){
			jgVarList = e_db.getEstiJgVarList();
			jgVarList_size = jgVarList.size();
		}
	}	
	

%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;
<%if(mode.equals("opt")){%>
	<%if(addCarAmts.length>0){%>
	te.length = <%= addCarAmts.length+1 %>;
	te.options[0].value = '///0';
	te.options[0].text = '옵션없음';
		<%	for(int i=0; i<addCarAmts.length; i++){
				ce_bean = addCarAmts[i];	%>
				te.options[<%=i+1%>].value = '<%=ce_bean.getCol_2_val()%>///<%=ce_bean.getEtc_content()%>';
				te.options[<%=i+1%>].text = '<%=ce_bean.getCol_2_val()%> (+<%=AddUtil.parseDecimal(ce_bean.getEtc_content())%>원)';
		<%	}%>
	<%}else{%>
		te.length = 1;
		te.options[0].value = '///0';
		te.options[0].text = '옵션없음';	
	<%}%>
	
	<%if(jgVarList_size>0){%>
	
	parent.form1.jg_code;
	parent.form1.jg_code.length = <%= jgVarList_size+1 %>;
	
	parent.form1.jg_code.options[0].value = '';
	parent.form1.jg_code.options[0].text = '=======선 택=======';
	
	<%	if(jgVarList_size > 0){
			for(int i = 0 ; i < jgVarList_size ; i++){
				Hashtable jgVar = (Hashtable)jgVarList.elementAt(i);			
  	%>
  				parent.form1.jg_code.options[<%=i+1%>].value = '<%=jgVar.get("SH_CODE")%>||<%=jgVar.get("JG_C")%>||<%=jgVar.get("JG_2")%>';
  				parent.form1.jg_code.options[<%=i+1%>].text = ' [<%= jgVar.get("SH_CODE") %>]<%= jgVar.get("CARS") %> ';
  	<%	
			}	
		}
	%>
	
	<%}%>
	
<%}else{%>
	<%if(car_size > 0){%>
	
		<%if(car_size2>0 && mode.equals("1") && from_page.equals("/acar/car_mst/car_mst_sh.jsp")){%>
			te.length = <%= car_size+1+car_size2+1 %>;
		<%}else{%>
			te.length = <%= car_size+1 %>;
		<%}%>
			te.options[0].value = '';
		
		<%if(mode.equals("3")){%>
			te.length = <%= car_size+2 %>;
			te.options[0].text = '최근';
		<%}else if(mode.equals("12") || mode.equals("13")){%>
			te.length = <%= car_size+2 %>;
			te.options[0].text = '사용중';
		<%}else{%>
			te.options[0].text = '선택';
		<%}%>
	
	<%	for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			if(mode.equals("1")){%>
					te.options[<%=i+1%>].value = '<%=car.get("CODE")%>';
					te.options[<%=i+1%>].text = '[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%>';
	
	<%		}else if(mode.equals("8")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CODE")%>';
					te.options[<%=i+1%>].text = '<%=car.get("CAR_NM")%>';
	
	<%		}else if(mode.equals("2") || mode.equals("4")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_ID")%>';
					te.options[<%=i+1%>].text = '<%=car.get("CAR_NAME")%>';
	
	<%		}else if(mode.equals("3")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_B_DT")%>';
					te.options[<%=i+1%>].text = ChangeDate('<%=car.get("CAR_B_DT")%>');
					te.options[<%=i+1%>].text = te.options[<%=i+1%>].text + '(<%=car.get("CNT")%>)';
	
	<%		}else if(mode.equals("10")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_SEQ")%><%=car.get("CAR_ID")%>';
					te.options[<%=i+1%>].text = '<%=car.get("CAR_NAME")%>';
	
	<%		}else if(mode.equals("12")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_U_SEQ")%><%=car.get("CAR_C_DT")%>';
					te.options[<%=i+1%>].text = '[<%=car.get("CAR_U_SEQ")%>]'+ChangeDate('<%=car.get("CAR_C_DT")%>');
	
	<%		}else if(mode.equals("14")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_SEQ")%><%=car.get("CAR_B_DT")%>';
					te.options[<%=i+1%>].text = '[<%=car.get("CAR_SEQ")%>]'+ChangeDate('<%=car.get("CAR_B_DT")%>');
				
	<%		}else if(mode.equals("15")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("JG_OPT_ST")%>';
					te.options[<%=i+1%>].text = '[<%=car.get("JG_OPT_ST")%>]'+'<%=car.get("JG_OPT_1")%>';
	
	<%		}else if(mode.equals("16")){%>	
					te.options[<%=i+1%>].value = '<%=car.get("CAR_K_DT")%>';
					te.options[<%=i+1%>].text =ChangeDate('<%=car.get("CAR_K_DT")%>');
					te.options[<%=i+1%>].text = te.options[<%=i+1%>].text + '(<%=car.get("CNT")%>)';
	<%		}
		}
	%>
	
	//미사용차종
	<%if(mode.equals("1") && from_page.equals("/acar/car_mst/car_mst_sh.jsp") && car_size2 >0 ){
		CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id);
	%>		
	te.options[<%=car_size+1%>].value = '';
	te.options[<%=car_size+1%>].text = '==미사용차종==';		
	<%	car_size++;
		for(int i=0; i<cm_r.length; i++){
			CarMstBean cm_bean = cm_r[i];
			if(cm_bean.getCar_yn().equals("N")){
				car_size++;
	%>
	te.options[<%=car_size%>].value = '<%=cm_bean.getCode()%>';
	te.options[<%=car_size%>].text = '(N)[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%>';
	
	<%		}
		}
	%>
	<%}%>
			
		<%if(mode.equals("3")){%>
			te.options[<%=car_size+1%>].value = '99999999';
			te.options[<%=car_size+1%>].text = '전체';
		<%}%>
			
		<%if(mode.equals("12") || mode.equals("13")){%>
			te.options[<%=car_size+1%>].value = '99999999';
			te.options[<%=car_size+1%>].text = '선택';
			te.options[<%=car_size+1%>].selected = true;				
		<%}%>
	
				
	<%}else{	%>
		
	<%	if(mode.equals("12")){%>		
				te.length = 1;
				te.options[0].value = '01<%=AddUtil.getDate()%>';
				te.options[0].text = '[01]<%=AddUtil.getDate()%>';
		<%}else{%>
				te.length = 1;
				te.options[0].value = '';
				te.options[0].text = '선택';
	<%	}%>
	<%}	%>
<%}	%>	
//-->
</script>
</head>
<body>
</body>
</html>
