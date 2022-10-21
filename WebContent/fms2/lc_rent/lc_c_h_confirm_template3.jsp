<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, acar.cont.*, acar.cls.*, acar.car_register.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<% 
	String firm_nm 			= request.getParameter("firm_nm")		==null? "":request.getParameter("firm_nm");
	String client_nm 		= request.getParameter("client_nm")		==null? "":request.getParameter("client_nm");
	String car_no 			= request.getParameter("car_no")		==null? "":request.getParameter("car_no");
	String car_nm 			= request.getParameter("car_nm")		==null? "":request.getParameter("car_nm");	// 차명
	String ssn 				= request.getParameter("ssn")			==null? "":request.getParameter("ssn");	// 법인등록번호 또는 생년월일
	String enp_no 			= request.getParameter("enp_no")		==null? "":request.getParameter("enp_no");	// 사업자등록번호
	String address 			= request.getParameter("address")		==null? "":request.getParameter("address");	// 사업장 주소 2018.01.10
	String rent_dt 			= request.getParameter("rent_dt")		==null? "":request.getParameter("rent_dt");	// 계약일자
	String car_color 		= request.getParameter("car_color")		==null? "":request.getParameter("car_color");	// 차량색상
	String rent_start_dt 	= request.getParameter("rent_start_dt")	==null? "":request.getParameter("rent_start_dt");// 이용기간 시작일
	String rent_end_dt 		= request.getParameter("rent_end_dt")	==null? "":request.getParameter("rent_end_dt");// 이용기간 종료일

	String client_id 	= request.getParameter("client_id")			==null? "":request.getParameter("client_id");
	String bus_id2 		= request.getParameter("bus_id2")			==null? "":request.getParameter("bus_id2");
	String pay_way 		= request.getParameter("pay_way")			==null? "":request.getParameter("pay_way");
	
	String view_good = request.getParameter("view_good")==null?"":request.getParameter("view_good");
	String view_tel = request.getParameter("view_tel")==null?"":request.getParameter("view_tel");
	String view_addr = request.getParameter("view_addr")==null?"":request.getParameter("view_addr");	

	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	
		
	AddContDatabase a_db	= AddContDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean sender_bean 	= new UsersBean();
	
	if(!user_id.equals("")){
		sender_bean = umd.getUsersBean(user_id);
	}
	
	String mail_yn = "";
	
	if(client_id.equals("") && !var5.equals("")){
		mail_yn = "Y";
		client_id = var5;		
		rent_l_cd = var2;		
		rent_mng_id = var4;		
	}	
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	String tel = client.getO_tel();
	
	if(tel.equals("")){
		tel = client.getM_tel();
	}
	
	if(tel.equals("")){
		tel = client.getH_tel();
	}
	
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
	int mgr_size = car_mgrs.size();

	for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);	
		if(tel.equals("") && mgr.getMgr_st().equals("계약담당자")){
			tel = mgr.getMgr_tel();
		}
		if(tel.equals("") && mgr.getMgr_st().equals("계약담당자")){
			tel = mgr.getMgr_m_tel();
		}
	}

	String mgr_nm = "";
	String mgr_tel = "";
			
	for(int i = 0 ; i < mgr_size ; i++){
		CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
		
		if(mgr.getMgr_st().equals("차량이용자")){
			mgr_nm = mgr.getMgr_nm();
			mgr_tel = mgr.getMgr_m_tel();
			if(mgr_tel.equals("")){
				tel = mgr.getMgr_tel();
			}	
		}		
	}	
	
	
	if(rent_dt.equals("")){
		rent_dt = base.getRent_dt();
	}
	if(rent_start_dt.equals("")){
		
		//대여료갯수조회(연장여부)
		int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);		
		
		Vector vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 0);
		if(vt.size() < 1){
			vt = af_db.getRentDtConMon(rent_mng_id, rent_l_cd, 1);
		}
		
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i); 
			rent_end_dt = String.valueOf(ht.get("RENT_END_DT"));
		}
		
		// 이용기간 시작일은 대여요금의 대여개시일
		ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(1));
		rent_start_dt = fees.getRent_start_dt();
		
		// 계약승계의 경우 이용기간 시작일은 계약승계날짜로 변경		2018.01.11
		String rent_suc_dt = af_db.getRentSucDt(rent_mng_id, rent_l_cd);
		if(rent_suc_dt.length() > 1){
			rent_start_dt = rent_suc_dt;
		}
		
		// 계약 연장이 있는 경우 마지막 연장계약의 대여만료일로 이용기간 종료일이 변경된다.
		ContFeeBean fees2 = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
		rent_end_dt = fees2.getRent_end_dt();
				
		// 임의 연장이 있는 경우 마지막 사용일로 이용기간 종료일이 변경된다.	2018.01.11
		Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
		int im_vt_size = im_vt.size();
		String im_rent_end_dt = "";
		if(im_vt_size > 0){
			Hashtable im_ht = (Hashtable)im_vt.elementAt(im_vt_size - 1);
			im_rent_end_dt = String.valueOf(im_ht.get("RENT_END_DT"));
			if(Integer.parseInt(im_rent_end_dt) > Integer.parseInt(rent_end_dt)){	// 임의 연장 기간 종료일이 계약 연장 종료일보다 큰 경우만 변경시킨다.
				rent_end_dt = im_rent_end_dt;
			}
		}
		
		//계약해지는 해지일자가 만료일자
		
		//해지정보
		ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
		if(!cls.getCls_dt().equals("")){
			rent_end_dt = cls.getCls_dt();
		}
	}
	
	if(car_no.equals("")){
		//차량등록정보
		if(!base.getCar_mng_id().equals("")){
			CarRegDatabase crd 		= CarRegDatabase.getInstance();
			cr_bean = crd.getCarRegBean(base.getCar_mng_id());
			car_no = cr_bean.getCar_no();
			car_nm = cr_bean.getCar_nm();
		}
	}
	
	if(address.equals("")){
		// 사업장 주소 2018.01.10
		address = "";
		if(!client.getO_addr().equals("")){
			address += "(";
		}
		address += client.getO_zip();
		if(!client.getO_addr().equals("")){
			address += ") ";
		}
		address += client.getO_addr();
	}	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<style>
	*{
		font-family: serif;
	}
</style>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    line-height: 1.8em;
    /* font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif; */
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */

.title{text-align:center;background-color: aliceblue;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}
/* #wrap{ font-family: 'Malgun Gothic'; vertical-align: middle; font-weight:bold;} */
table, th, td{	border: 1px solid black;  text-align: center; line-height: 30px;}	
table{	border-collapse: collapse;	}
</style>
<script type="text/javascript">

</script>
</head>
<body topmargin=0 leftmargin=0>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>
<div class="paper">
	<div class="content">
		<div class="wrap" style="width:100%;">
			<div id="print_template_a">
				<div align="right"><img src="https://fms1.amazoncar.co.kr/acar/images/logo_doc.png"></div>
			</div>
			<br>
			<br>
			<div style="font-weight:bold;">
				<div align="center" style="font-size:30px;">계 약 사 실 확 인 서</div>
			</div>
			<br>			
			<div style="font-weight:bold;">
				<br>
				<div>&nbsp;</div>
				<div>&nbsp;</div>
				<div>계약자 <%=client.getFirm_nm()%> <%if(client.getClient_st().equals("2")){%>(<%=client.getSsn1()%>)<%}else{%>(<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>)<%}%>는 주식회사 아마존카와 아래와 같이 자동차대여계약을 체결하고 이용하고 있음을 확인합니다.</div>					
				<div>&nbsp;</div>
				<div>&nbsp;</div>
				<div>&nbsp;</div>
				<div align="center">- 아 래 - </div>
				<div>&nbsp;</div>
				<div>&nbsp;</div>
				<div>1. 계약자 : <%=client.getFirm_nm()%><%if(!client.getFirm_nm().equals(client.getClient_nm())){%><%=client.getClient_nm()%><%}%></div>
				<div>2. <%if(client.getClient_st().equals("2")){%>생년월일<%}else{%>사업자등록번호<%}%> : <%if(client.getClient_st().equals("2")){%><%=client.getSsn1()%><%}else{%><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%><%}%></div>
				<div>3. 계약일자 : <%=AddUtil.getDate3(rent_dt)%></div>
				<div>4. 이용기간 : <%=AddUtil.getDate3(rent_start_dt)%>부터 <%=AddUtil.getDate3(rent_end_dt)%>까지</div>
				<div>5. 대여자동차 : <%=car_no%> (<%=car_nm%>)</div>
				<% int count = 5; %>
				<% if(view_good.equals("Y")){
					count++;
				%>
				<div><%=count%>. 상품구분 : <%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%></div>
				<%} %>
				<% if(view_tel.equals("Y")){
					count++;
				%>
				<div><%=count%>. 연락처 : <%=tel%>	 <%if(!mgr_tel.equals(tel) && !mgr_tel.equals("")){%>(차량이용자 : <%=mgr_nm%> <%=mgr_tel%>)<%}%>
				</div>
				<%} %>
				<% if(view_addr.equals("Y")){
					count++;
				%>				
				<div><%=count%>. 주소 : <%=address%></div>
				<%} %>
				<div>&nbsp;</div>
				<div>&nbsp;</div>				
			</div>			
			<div align="center">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_no_stamp.gif" width="400">
				<img src="https://fms1.amazoncar.co.kr/acar/main_car_hp/images/ceo_stamp.jpg" height="90" width="90" style="">
			</div>	
			    <div>&nbsp;</div>	
				<div align="right" >07236 서울시 영등포구 의사당대로 8 (태흥빌딩 802호)</div>
				<div align="right">T) 02-392-4243, F) 02-757-0803</div>
				<%if(sender_bean.getUser_nm().equals("")){%>
				<div align="right">담당자장혁준과장, 02-6263-6383</div>
				<%}else{%>
				<div align="right">담당자 <%=sender_bean.getUser_nm()%><%=sender_bean.getUser_pos()%>, <%=sender_bean.getHot_tel()%></div>
				<%}%>
									
		</div>
	</div>
</div>
</body>
<script>
	
// window.print();
	
</script>
</html>