<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.car_register.*, acar.client.*, acar.cont.*, acar.car_mst.*, acar.car_office.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="shDb"      class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "07", "03");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//탁송의뢰 1번
	ConsignmentBean b_cons = cs_db.getConsignment(cons_no, 1);
	
	//차량관리담당자 가져 올라고 
//	ContBaseBean 	base 		= a_db.getCont(b_cons.getRent_mng_id(), b_cons.getRent_l_cd());
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	//의뢰자
	UsersBean sender_bean 	= umd.getUsersBean(doc.getUser_id1());
	
		
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
	
	Vector  codes2 = new Vector();
	int c_size2 = 0;	

	/*
	if (b_cons.getOff_id().equals("002740")||b_cons.getOff_id().equals("009217") ){
		codes2 = c_db.getCodeAllV_0022_t("0022");	
		c_size2 = codes2.size();
	} else	if ( b_cons.getOff_id().equals("010255")  ) {
		codes2 = c_db.getCodeAllV_0022_w("0022");	
		c_size2 = codes2.size();				
	} else {
		codes2 = c_db.getCodeAllV_0022_all("0022");	
		c_size2= codes2.size();
	}	 
	*/
	
	codes2 = c_db.getCodeAllV_0022_all("0022");	
	c_size2= codes2.size();
	
	String white = "";
	String disabled = "";
	white = "white";
	disabled = "disabled";
	
	if(from_page.equals("/fms2/consignment_new/cons_oil_doc_frame.jsp")){
		white = "white";
		disabled = "disabled";		
	}
	
	//파일(20190510)
	String content_code = "CONSIGNMENT";
	String content_seq  = cons_no;
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	String file_type2 = "";
	String seq2 = "";
	String file_name2 = "";
	
	String file_type3 = "";
	String seq3 = "";
	String file_name3 = "";
	
	String file_type4 = "";
	String seq4 = "";
	String file_name4 = "";
	
	String file_type5 = "";
	String seq5 = "";
	String file_name5 = "";
	
	String file_type6 = "";
	String seq6 = "";
	String file_name6 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);
	
		if((content_seq+"1"+"_po").equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
	 	}else if((content_seq+"2"+"_po").equals(aht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(aht.get("FILE_NAME"));
			file_type2 = String.valueOf(aht.get("FILE_TYPE"));
			seq2 = String.valueOf(aht.get("SEQ"));
	
		}else if((content_seq+"1"+"_pk").equals(aht.get("CONTENT_SEQ"))){
			file_name3 = String.valueOf(aht.get("FILE_NAME"));
			file_type3 = String.valueOf(aht.get("FILE_TYPE"));
			seq3 = String.valueOf(aht.get("SEQ"));
	
		}else if((content_seq+"2"+"_pk").equals(aht.get("CONTENT_SEQ"))){
			file_name4 = String.valueOf(aht.get("FILE_NAME"));
			file_type4 = String.valueOf(aht.get("FILE_TYPE"));
			seq4 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+"1"+"_ws").equals(aht.get("CONTENT_SEQ"))){	//세차비 (20190509)
			file_name5 = String.valueOf(aht.get("FILE_NAME"));
			file_type5 = String.valueOf(aht.get("FILE_TYPE"));
			seq5 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+"2"+"_ws").equals(aht.get("CONTENT_SEQ"))){	//세차비 (20190509)
			file_name6 = String.valueOf(aht.get("FILE_NAME"));
			file_type6 = String.valueOf(aht.get("FILE_TYPE"));
			seq6 = String.valueOf(aht.get("SEQ"));
		}
	}	
	
	boolean userFlag = nm_db.getWorkAuthUser("전산팀",user_id);
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//길이구하기
function cut_length(f,cut_len) {
	var max_len = f.length;
	var len = 0;
	var rf = "";
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
		if(len <= cut_len){
			rf=rf+t;
		}
	}
	alert(len);	
	alert(rf);
//	return rf;
}

	//리스트
	function list(){
		var fm = document.form1;			
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			if(fm.from_page.value == ''){
				fm.action = 'cons_settle_frame.jsp';
			}else{
				fm.action = fm.from_page.value;
			}
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//탁송업체 조회
	function search_off()
	{
		window.open("/acar/cus0601/cus0602_frame.jsp?from_page=/fms2/consignment_new/cons_reg_step3.jsp", "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//탁송업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		window.open("/acar/cus0601/cus0602_d_frame.jsp?from_page=/fms2/consignment_new/cons_reg_step3.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=200, scrollbars=yes, status=yes, resizable=yes");
	}		
		
	//자동차 조회
	function search_car(idx)
	{
		window.open("/tax/pop_search/s_car.jsp?go_url=/fms2/consignment_new/cons_reg_step3.jsp&s_kd=2&idx="+idx, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차 보기
	function view_car(idx)
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 탁송업체가 없습니다."); return;}
		if(fm.car_mng_id[idx].value == ""){ alert("선택된 자동차가 없습니다."); return;}	
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_mng_id="+fm.car_mng_id[idx].value+"&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}			

	//탁송구분에 따른 셋팅
	function cng_input(st){
		var fm = document.form1;
		
		var cons_su = toInt(fm.cons_su.value);
		
		if(cons_su == 1 && st == 2){
			fm.cons_su.value = 2;
			tr_cons1_1.style.display	= '';
			tr_cons1_2.style.display	= '';
			tr_cons1_3.style.display	= '';
			tr_cons1_4.style.display	= '';
			tr_cons1_5.style.display	= '';
		}		
	}	
	
	//차량대수에 따른 디스플레이
	function cng_input2(cons_su){
		var fm = document.form1;		
		var cons_su = toInt(cons_su);
		
		if(cons_su >10){
			alert('입력가능한 최대건수는 10건 입니다.');
			return;
		}		
		
		<%for(int i=1;i<3;i++){%>
		if(cons_su > <%=i%>){
			tr_cons<%=i%>_1.style.display	= '';
			tr_cons<%=i%>_2.style.display	= '';			
			tr_cons<%=i%>_3.style.display	= '';
			tr_cons<%=i%>_4.style.display	= '';
			tr_cons<%=i%>_5.style.display	= '';
		}else{
			tr_cons<%=i%>_1.style.display	= 'none';
			tr_cons<%=i%>_2.style.display	= 'none';
			tr_cons<%=i%>_3.style.display	= 'none';
			tr_cons<%=i%>_4.style.display	= 'none';
			tr_cons<%=i%>_5.style.display	= 'none';
		}
		<%}%>			
			
	}		
	
	//출발/도착 구분에 따른 팝업
	function cng_input3(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 400;
		var firm_nm = '';				
		var req_id 	= fm.req_id.value;
		var s_kd 	= '1';
				
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}

		if(value == '2'){ 
			width 	= 800;
			firm_nm = fm.firm_nm[idx].value;
			if(firm_nm == '아마존카' || firm_nm == '(주)아마존카'){
				firm_nm = fm.car_no[idx].value;
				s_kd = '2';
			}
		}
		
		window.open("s_place.jsp?go_url=/fms2/consignment_new/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&req_id="+req_id, "PLACE", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//출발/도착 담당자 조회
	function cng_input5(st, value, idx){
		var fm = document.form1;		
		var width 	= 600;
		var height 	= 500;
		var firm_nm = '';
		
		if(st == 'from' && fm.from_st[idx].value == ''){		alert('출발 구분을 선택하십시오.'); 	return;		}
		if(st == 'to' && fm.to_st[idx].value == ''){			alert('도착 구분을 선택하십시오.'); 	return;		}

		if(st == 'from')		firm_nm 	= fm.from_comp[idx].value;
		if(st == 'to')			firm_nm 	= fm.to_comp[idx].value;
		
		if(firm_nm == ''){ 		alert('구분을 선택하여 장소를 먼저 선택하여 주십시오.'); 	return; }
		
		if(value == '1') 		firm_nm 	= replaceString('(주)아마존카 ','',firm_nm);
		
		if(value == '3'){		alert('협력업체는 담당자 검색이 없습니다.');	return; }
		
		window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step1.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&rent_mng_id="+fm.rent_mng_id[idx].value+"&rent_l_cd="+fm.rent_l_cd[idx].value+"&car_no="+fm.car_no[idx].value, "MAN", "left=10, top=10, width="+width+", height=500, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//운전자 조회
	function cng_input6(st, value, idx){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 700;		
		var firm_nm = '<%=b_cons.getOff_nm()%>';
		if('<%=b_cons.getOff_id()%>' == '003158'){
			width 	= 600;
			height 	= 700;
			value = '4';
			s_kd  = 2;
			if(<%=b_cons.getCons_su()%> > 1){
				if(fm.driver_nm[idx].value != '')		firm_nm = fm.driver_nm[idx].value;
				else									firm_nm = '';
			}else{
				if(fm.driver_nm.value != '')			firm_nm = fm.driver_nm.value;
				else									firm_nm = '';			
			}
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd="+s_kd+"&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");					
		}else{				
			window.open("s_man.jsp?go_url=/fms2/consignment_new/cons_reg_step3.jsp&st="+st+"&value="+value+"&idx="+idx+"&s_kd=1&t_wd="+firm_nm+"&size=<%=b_cons.getCons_su()%>", "MAN", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
		}
	}			
	
	//탁송사유별 셋팅
	function cng_input4(value, idx){
		var fm = document.form1;		
		if(value != '20'){
			fm.cost_st[idx].value 	= '1';
			fm.pay_st[idx].value 	= '2';
		}
		if(value == '1' || value == '2' || value == '3' || value == '4' || value == '5' || value == '6' || value == '7' || value == '15' || value == '16'){
			fm.from_st[idx].value 	= '1';
			fm.to_st[idx].value 	= '2';
		}
		if(value == '8' || value == '9' || value == '10' || value == '11' || value == '12' || value == '13' || value == '14' || value == '17'){
			fm.from_st[idx].value 	= '2';
			fm.to_st[idx].value 	= '1';		
		}		
	}				
	
	//예정일시 셋팅
	function cng_input7(st, idx){
		var fm = document.form1;	
		
		if(st == 'from'){
			if(fm.from_est_chk[idx].checked == true){
				fm.from_est_dt[idx].value 	= fm.from_req_dt[idx].value;
				fm.from_est_h[idx].value 	= fm.from_req_h[idx].value;
				fm.from_est_s[idx].value 	= fm.from_req_s[idx].value;						
			}	
		}else{
			if(fm.to_est_chk[idx].checked == true){		
				fm.to_est_dt[idx].value 	= fm.to_req_dt[idx].value;
				fm.to_est_h[idx].value 		= fm.to_req_h[idx].value;
				fm.to_est_s[idx].value 		= fm.to_req_s[idx].value;									
			}
		}
	}
	
	function cons_delete(mode, seq){
		var fm = document.form1;
		
		fm.mode.value 		= mode;
		fm.del_seq.value 	= seq;
		
		<% if(!userFlag) {%>
		if($("input[name=driver_nm]").eq(0).val() || $("input[name=driver_nm]").eq(1).val()) {
			alert("탁송 기사가 배정되었습니다. 탁송사에 문의하세요.");
			return;
		}
		<%}%>
		
		if(confirm('삭제하시겠습니까?')){
		if(confirm('진짜로 삭제하시겠습니까?')){
			fm.action='cons_delete.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}
	}		
	
	//탁송관리자 결재취소
	function doc_sanction_cancel(){
		var fm = document.form1;
		fm.cmd.value="cancel";
		if(confirm('결재취소 하시겠습니까?')){	
			fm.action='cons_conf_a.jsp';
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		var size = toInt(fm.cons_su.value);
		
		fm.doc_bit.value = doc_bit;
		
		for(i=0; i<size ; i++){		
			if(size == 1){
				if(fm.from_dt.value == "" || fm.from_h.value == "" || fm.from_s.value == "") 			{ 	alert((i+1)+"번 자동차 : 출발-일시를 입력하십시오."); 					return;	}					
				if(fm.to_dt.value == ""   || fm.to_h.value == ""   || fm.to_s.value == "") 				{ 	alert((i+1)+"번 자동차 : 도착-일시를 입력하십시오."); 					return;	}			
				//if(toInt(parseDigit(fm.other_amt[i].value)) > 0 &&  fm.other.value == "") 				{ 	alert((i+1)+"번 자동차 : 기타금액 내용을 입력하십시오."); 				return;	}
				if(fm.cost_st2.value == "2" && fm.pay_st2.value == "1"){
					if(toInt(parseDigit(fm.cust_amt[i].value)) == 0)									{ 	alert((i+1)+"번 자동차 : 고객비용 탁송료를 입력하십시오."); 			return;	}				
					if(toInt(parseDigit(fm.cust_amt[i].value)) > 0 &&  fm.cust_pay_dt.value == "")		{ 	alert((i+1)+"번 자동차 : 고객비용 탁송료 수령일자를 입력하십시오."); 	return;	}				
				}
				//20091101부터 정산시 주행거리 입력 필수
				if(toInt(replaceString('-','',fm.from_dt.value)) >= 20091101){
					if(fm.tot_dist.value == "" || fm.tot_dist.value == "0")								{ 	alert((i+1)+"번 자동차 : 주행거리를 입력하십시오."); 					return;	}					
					//20110713 입력값 체크
					/*
					if(toInt(fm.v_tot_dist.value) >1){
						var dist_cha = toInt(parseDigit(fm.v_tot_dist.value))-toInt(parseDigit(fm.tot_dist.value));
						if(dist_cha > 2000){
							alert((i+1)+"번 자동차 : 최종주행거리가 "+fm.v_tot_dist.value+"km입니다. 입력한 주행거리가 오차범위(-2000)를 초과합니다."); 			return;							
						}
					}	
					*/		
				}
				// 20180411 누적주행거리 입력 제한(콤마를 제외한 6자리까지만 입력 가능)
				if(toInt(parseDigit(fm.tot_dist.value))>999999){					{ 	alert((i+1)+"번 자동차 : 주행거리는 999,999km를 넘을 수 없습니다."); 					return;	}
				}
				/* if(fm.wash_yn.value=="M"||fm.wash_yn.value=="H"){	//세차수수료체크(20190509)
					if(fm.wash_fee[i].value==""||fm.wash_fee[i].value==0){	alert((i+1)+"번 자동차의 세차수수료를 입력해주세요.");		return;		}
				} */
			}else{
				if(fm.from_dt[i].value == "" || fm.from_h[i].value == "" || fm.from_s[i].value == "") 	{ 	alert((i+1)+"번 자동차 : 출발-일시를 입력하십시오."); 					return;	}					
				if(fm.to_dt[i].value == ""   || fm.to_h[i].value == ""   || fm.to_s[i].value == "") 	{ 	alert((i+1)+"번 자동차 : 도착-일시를 입력하십시오."); 					return;	}
				//if(toInt(parseDigit(fm.other_amt[i].value)) > 0 &&  fm.other[i].value == "") 			{ 	alert((i+1)+"번 자동차 : 기타금액 내용을 입력하십시오."); 				return;	}							
				if(fm.cost_st2[i].value == "2" && fm.pay_st2[i].value == "1"){
					if(toInt(parseDigit(fm.cust_amt[i].value)) == 0)									{ 	alert((i+1)+"번 자동차 : 고객비용 탁송료를 입력하십시오."); 			return;	}				
					if(toInt(parseDigit(fm.cust_amt[i].value)) > 0 &&  fm.cust_pay_dt[i].value == "")	{ 	alert((i+1)+"번 자동차 : 고객비용 탁송료 수령일자를 입력하십시오."); 	return;	}				
				}
				//20091101부터 정산시 주행거리 입력 필수
				if(toInt(replaceString('-','',fm.from_dt[i].value)) >= 20091101){
					if(fm.tot_dist[i].value == "" || fm.tot_dist[i].value == "0")						{ 	alert((i+1)+"번 자동차 : 주행거리를 입력하십시오."); 					return;	}					
					//20110713 입력값 체크
					/*
					if(toInt(fm.v_tot_dist[i].value) >1){
						var dist_cha = toInt(parseDigit(fm.v_tot_dist[i].value))-toInt(parseDigit(fm.tot_dist[i].value));
						if(dist_cha > 2000){
							alert((i+1)+"번 자동차 : 최종주행거리가 "+fm.v_tot_dist[i].value+"km입니다. 입력한 주행거리가 오차범위(-2000)를 초과합니다."); 			return;							
						}
					}
					*/
				}
				// 20180411 누적주행거리 입력 제한(콤마를 제외한 6자리까지만 입력 가능)
				if(toInt(parseDigit(fm.tot_dist[i].value))>999999){					{ 	alert((i+1)+"번 자동차 : 주행거리는 999,999km를 넘을 수 없습니다."); 					return;	}
				}
				
				/* if(fm.wash_yn[i].value=="M"||fm.wash_yn[i].value=="H"){	//세차수수료체크(20190509)
					if(fm.wash_fee[i].value==""||fm.wash_fee[i].value==0){	alert((i+1)+"번 자동차의 세차수수료를 입력해주세요.");		return;		}
				} */
			}
			//if(toInt(parseDigit(fm.cons_amt[i].value)) == 0)			 								{ 	alert((i+1)+"번 자동차 : 탁송료를 입력하십시오."); 						return;	}
		}
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='cons_reg_step3_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}									
	}	
	
	function save(idx){
		var fm = document.form1;
		
		fm.u_seq.value = idx;
		fm.mode.value = 'driver_modify';
		
		if(confirm('수정하시겠습니까???')){		
			fm.action='cons_reg_step3_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
	}
	
	//탁송의뢰서 출력
	function ConsPrint(seq){
		var fm = document.form1;	
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no=<%=cons_no%>&seq="+seq+"&step=2", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	//금액 셋팅
	function set_amt(){
		var fm = document.form1;	
		var size = toInt(fm.cons_su.value);
		
		fm.cons_amt[size].value 		= 0;
		fm.cons_other_amt[size].value 		= 0;
		fm.oil_amt[size].value 			= 0;
		fm.wash_amt[size].value 		= 0;
		fm.wash_card_amt[size].value 	= 0;
		fm.oil_card_amt[size].value 	= 0;
		fm.stot_amt[size].value		= 0;
		fm.other_amt[size].value 		= 0;
		fm.tot_amt[size].value 			= 0;
		fm.cust_amt[size].value 		= 0;
		fm.etc1_amt[size].value 		= 0;
		fm.etc2_amt[size].value 		= 0;
		fm.wash_fee[size].value 		= 0;		//세차수수료추가(20190509)
		
		for(i=0; i<size ; i++){
		
			fm.tot_amt[i].value 			= parseDecimal( toInt(parseDigit(fm.cons_amt[i].value)) +  toInt(parseDigit(fm.cons_other_amt[i].value)) + toInt(parseDigit(fm.oil_amt[i].value)) + toInt(parseDigit(fm.wash_amt[i].value)) + toInt(parseDigit(fm.other_amt[i].value))  + toInt(parseDigit(fm.etc1_amt[i].value))   + toInt(parseDigit(fm.etc2_amt[i].value)) + toInt(parseDigit(fm.wash_fee[i].value)));
			fm.stot_amt[i].value 			= parseDecimal( toInt(parseDigit(fm.oil_amt[i].value)) + toInt(parseDigit(fm.oil_card_amt[i].value)) );
			
			fm.cons_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.cons_amt[size].value)) + toInt(parseDigit(fm.cons_amt[i].value)) );
		
			fm.wash_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.wash_amt[size].value)) + toInt(parseDigit(fm.wash_amt[i].value)) );
			fm.wash_card_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.wash_card_amt[size].value)) + toInt(parseDigit(fm.wash_card_amt[i].value)) );
			fm.oil_card_amt[size].value 	= parseDecimal( toInt(parseDigit(fm.oil_card_amt[size].value)) + toInt(parseDigit(fm.oil_card_amt[i].value)) );
			fm.oil_amt[size].value 			= parseDecimal( toInt(parseDigit(fm.oil_amt[size].value)) + toInt(parseDigit(fm.oil_amt[i].value)) );
		
			fm.stot_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.stot_amt[size].value)) + toInt(parseDigit(fm.stot_amt[i].value)) );
			fm.cons_other_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.cons_other_amt[size].value)) + toInt(parseDigit(fm.cons_other_amt[i].value)) );
			fm.other_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.other_amt[size].value)) + toInt(parseDigit(fm.other_amt[i].value)) );
			fm.etc1_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.etc1_amt[size].value)) + toInt(parseDigit(fm.etc1_amt[i].value)) );
			fm.etc2_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.etc2_amt[size].value)) + toInt(parseDigit(fm.etc2_amt[i].value)) );
			fm.tot_amt[size].value 			= parseDecimal( toInt(parseDigit(fm.tot_amt[size].value)) + toInt(parseDigit(fm.tot_amt[i].value)) );
			fm.cust_amt[size].value 		= parseDecimal( toInt(parseDigit(fm.cust_amt[size].value)) + toInt(parseDigit(fm.cust_amt[i].value)) );
			fm.wash_fee[size].value 		= parseDecimal( toInt(parseDigit(fm.wash_fee[size].value)) + toInt(parseDigit(fm.wash_fee[i].value)) );
			
		}
	}
	
	//의뢰자 변경
	function doc_id_cng(){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 200;		
		window.open("cons_reg_cng.jsp?auth_rw=<%=auth_rw%>&cons_no=<%=cons_no%>", "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
	//차종내역 보기
	function view_car_service(car_mng_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+car_mng_id+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
	
	//유류배경감요청문서기안
	function M_doc_action(st, m_doc_code, seq1, seq2, buy_user_id, doc_bit, doc_no){
		var fm = document.form1;
		fm.st.value 		= st;		
		fm.m_doc_code.value 	= m_doc_code;
		fm.seq1.value 		= seq1;
		fm.seq2.value 		= seq2;
		fm.buy_user_id.value 	= buy_user_id;
		fm.doc_bit.value 	= doc_bit;
		fm.doc_no.value 	= '';		
		fm.action = 'cons_oil_doc_u.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//탁송업체 탁송료 조회
	function search_off_amt(idx, from_comp, to_comp)
	{
		var fm = document.form1;		
		var o_url = "/fms2/cons_cost/s_cons_cost.jsp?idx="+idx+"&car_comp_id=0000&car_cd=&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+from_comp+"&udt_st="+to_comp;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}			
	
	//주유카드 전표등록
	function CardDocReg(car_no, seq, gubun){  //:gubun: w->wash, o->oil
		var fm = document.form1;
		
		fm.action = "/card/doc_reg/cons_doc_reg_i.jsp?gubun="+gubun+"&car_no="+car_no+"&seq="+seq;
		window.open("about:blank", "CardDocView", "left=20, top=20, width=1100, height=680, resizable=yes, scrollbars=yes, status=yes");
		fm.target = "CardDocView";
		fm.submit();
	}
	
	//주유카드 전표등록
	function CardDocView(car_no, seq, gubun){
		var fm = document.form1;
		
		fm.action = "/card/doc_app/cons_doc_reg_u.jsp?guubn="+gubun+"&car_no="+car_no+"&seq="+seq;
		window.open("about:blank", "CardDocView", "left=20, top=20, width=1100, height=680, resizable=yes, scrollbars=yes, status=yes");
		fm.target = "CardDocView";
		fm.submit();
	}
	
	//스캔등록
	function scan_reg(cons_no, seq, gubun){
		window.open("reg_scan.jsp?cons_no="+cons_no+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&seq="+seq+"&file_st="+gubun, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	//스캔삭제
	function scan_del(cons_no, seq, gubun){
		var theForm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		theForm.target = "i_no"
		theForm.action = "del_scan_a.jsp?cons_no="+cons_no+"&seq="+seq+"&gubun="+gubun;
		theForm.submit();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/consignment/"+theURL;
		window.open(theURL,winName,features);
	}	

//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='cons_no' value='<%=cons_no%>'>
  <input type='hidden' name='off_id' value='<%=b_cons.getOff_id()%>'>
  <input type='hidden' name='off_nm' value='<%=b_cons.getOff_nm()%>'>
  <input type='hidden' name='reg_code' value='<%=b_cons.getReg_code()%>'>
<!--<input type='hidden' name='req_id' value='<%=doc.getUser_id1()%>'>-->
  <input type='hidden' name="doc_no" 	value="<%=doc.getDoc_no()%>">  
  <input type='hidden' name="doc_bit" value="<%=doc_bit%>">
  <input type='hidden' name="del_seq" value="">  
  <input type='hidden' name="u_seq" value="">  
  
  <input type='hidden' name='st' 	 value=''>
  <input type='hidden' name='m_doc_code' value=''>  
  <input type='hidden' name='seq1' 	 value=''>
  <input type='hidden' name='seq2' 	 value=''>
  <input type='hidden' name='buy_user_id' value=''>    
  
  <input type='hidden' name='cmd' 	 value=''>
  <input type='hidden' name='sender_pos' 	 value='<%=sender_bean.getUser_pos()%>'>
  <input type='hidden' name='sender_nm' 	 value='<%=sender_bean.getUser_nm()%>'>
   
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 탁송관리 > <span class=style5>탁송의뢰정산</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td align='right'><a href="javascript:list()"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  	
                <tr> 
                    <td width='13%' class='title'>탁송번호</td>
                    <td colspan="3">&nbsp;
        			  <%=cons_no%> 
        			</td>
                </tr>
                <tr> 
                    <td width='13%' class='title'>탁송업체</td>
                    <td colspan="3">&nbsp;
        			  <%=b_cons.getOff_nm()%>
        			  <%if(white.equals("")){%>
        			  <span class="b"><a href="javascript:view_off()"><img src="/acar/images/center/button_in_see.gif" align=absmiddle></a></span>
        			  <%}%>
        			</td>
                </tr>		  
                <tr> 
                    <td width='13%' class='title'>탁송구분</td>
                    <td width="37%">&nbsp;
        			  <input type='radio' name="cons_st" value='1' <%if(b_cons.getCons_st().equals("1")){%>checked<%}%> <%=disabled%>>
        				편도
        			  <input type='radio' name="cons_st" value='2' <%if(b_cons.getCons_st().equals("2")){%>checked<%}%> <%=disabled%>>
        				왕복
        			</td>		  		  		  
                    <td width='13%' class='title'>차량대수</td>
                    <td width="37%">&nbsp;
                      <input type='text' name="cons_su" value='<%=b_cons.getCons_su()%>' size='2' class='<%=white%>text'><!-- onBlur='javscript:cng_input2(this.value);-->
        			  &nbsp;건
                    </td>
                </tr>
                <tr> 
                    <td width='13%' class='title'>사후입력여부</td>
                    <td colspan="3">&nbsp;
					<input type="checkbox" name="after_yn" value="Y" <%if(b_cons.getAfter_yn().equals("Y")){%>selected<%}%>>
        			  (탁송완료건 사후입력일때)
                </tr>    
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class='line'> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13% rowspan="2">결재</td>
                    <td class=title width=15%>지점명</td>
                    <td class=title width=11%>담당자</td>
                    <td class=title width=11%>수신</td>
                    <td class=title width=13%>정산</td>
                    <td class=title width=12%>청구</td>
                    <td class=title width=12%>담당자확인</td>
                    <td class=title width=13%>탁송관리자</td>
                </tr>
                <tr>
                    <td align="center"><font color="#999999"><%=sender_bean.getBr_nm()%></font></td>
                    <td align="center"><font color="#999999"><%=sender_bean.getUser_pos()%> <%=sender_bean.getUser_nm()%><br><%=doc.getUser_dt1()%><%if(!from_page.equals("/fms2/consignment_new/cons_oil_doc_frame.jsp")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%><br><a href="javascript:doc_id_cng();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_modify_b.gif" align="absbottom" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(doc.getUser_dt3().equals("") && doc.getUser_id2().equals(user_id)){%><!--<a href="javascript:doc_sanction('3')">결재</a>--><%}%>&nbsp;</font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%></font></td>
        			<td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt5()%><%if(!doc.getUser_dt4().equals("") && doc.getUser_dt5().equals("") && (doc.getUser_id1().equals(user_id)||nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id))){%><a href="javascript:doc_sanction('5');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absbottom" border="0"></a><%}%>&nbsp;</font></td>
        			<td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>

					<%if(!doc.getUser_dt6().equals("") && b_cons.getPay_dt().equals("") && nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%>
						<br><a href="javascript:doc_sanction_cancel();" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_cancel.gif" align="absbottom" border="0">
					<%}%>
						
						<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%><%if(!doc.getUser_dt4().equals("") && doc.getUser_dt6().equals("")){%><a href="javascript:doc_sanction('6');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absbottom" border="0"></a><%}%><%}%></font></td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
	    <td align="right" style='height:1; background-color=e5e5e5;'></td>
	</tr>	
	<tr>
        <td></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
    		    <tr>
        		    <td width="3%" rowspan="3" class='title'>연번</td>
        		    <td width="9%" rowspan="3" class='title'>차량번호</td>
        		    <td width="8%" rowspan="3" class='title'>출발일시</td>
        		    <td width="8%" rowspan="3" class='title'>도착일시</td>			
        		    <td colspan="12" class='title'>청구금액</td>
        		    <td width="8%" rowspan="3" class='title'>누적주행거리</td>													
        		    <td colspan="2" class='title'>고객부담</td>			
    	        </tr>
    		    <tr>
        		    <td width="6%" class='title' rowspan="2">탁송료</td>        		 
        	        <td width="5%" class='title' colspan="2">세차비</td>
        	        <td width="5%" class='title' rowspan="2">세차<br>수수료</td>
        		    <td class='title' colspan="3">유류비</td>
        		    <td class='title' colspan="4">기타</td>					
        		    <td width="8%" class='title' rowspan="2">합계<br/>(법인카드제외)</td>
        		    <td width="6%" class='title' rowspan="2">금액</td>
        		    <td width="7%" class='title' rowspan="2">수령일자</td>
    		    </tr>
				<tr>
					<td width="7%" class='title'>법인카드</td>
					<td width="8%" class='title'>청구금액<br>(현금/개인카드)</td>
					<td width="7%" class='title'>법인카드</td>
					<td width="8%" class='title'>청구금액<br>(현금/개인카드)</td>					
					<td width="6%" class='title'>소계</td>
					<td width="4%" class='title'>외부탁송료</td>
					<td width="4%" class='title'>주차비</td>
					<td width="4%" class='title'>보증수리<br>대행</td>
					<td width="4%" class='title'>검사대행</td>
				</tr>
		  <%for(int j=0; j<b_cons.getCons_su(); j++){
				ConsignmentBean cons 		= cs_db.getConsignment(cons_no, j+1);%>
		  <%		String from_dt = "";
			  		String from_h = "";
					String from_s = "";
					String get_from_dt = cons.getFrom_dt();
					if(get_from_dt.equals("")) get_from_dt = cons.getFrom_est_dt();
					if(get_from_dt.length() == 12){
						from_dt = get_from_dt.substring(0,8);
						from_h 	= get_from_dt.substring(8,10);
						from_s	= get_from_dt.substring(10,12);
					}
					String to_dt = "";
			  		String to_h = "";
					String to_s = "";
					String get_to_dt = cons.getTo_dt();
					if(get_to_dt.equals("")) get_to_dt = cons.getTo_est_dt();
			  		if(get_to_dt.length() == 12){
						to_dt 	= get_to_dt.substring(0,8);
						to_h 	= get_to_dt.substring(8,10);
						to_s 	= get_to_dt.substring(10,12);
					}
					
			  		String prev_car_no = cons.getCar_no();
					String car_no = "";
					if( prev_car_no.length() > 10 ) {
						car_no = cs_db.getCarNo(cons_no, j+1);
					}
					car_no = car_no == "" ? prev_car_no : car_no;
					%>						
		        <tr>
        		    <td align="center"><%=j+1%></td>
        			<td align="center"><%=car_no%></td>
        		    <td align="center"><input type='text' name="from_dt" value='<%=AddUtil.ChangeDate2(from_dt)%>' size='11' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'><br>
        			  <input type='text' name="from_h" value='<%=from_h%>' size='1' maxlength="2" class='default'>시
        			  <input type='text' name="from_s" value='<%=from_s%>' size='1' maxlength="2" class='default'>분</td>
        			<td align="center"><input type='text' name="to_dt" value='<%=AddUtil.ChangeDate2(to_dt)%>' size='11' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'><br>
        			  <input type='text' name="to_h" value='<%=to_h%>' size='1' maxlength="2" class='default'>시
        			  <input type='text' name="to_s" value='<%=to_s%>' size='1' maxlength="2" class='default'>분</td>			
        		    <td align="center"><input type='text' name="cons_amt" value='<%=AddUtil.parseDecimal(cons.getCons_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>
        		        <%if(b_cons.getOff_nm().equals("(주)삼진특수")){%>
        		            <span class="b"><a href="javascript:search_off_amt('<%=j%>','<%=cons.getFrom_place()%>','<%=cons.getTo_place()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        		        <%}%>
        		    </td>        		 
        		    <td align="center">
					<input type='text' name="wash_card_amt" value='<%=AddUtil.parseDecimal(cons.getWash_card_amt())%>' size='6' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'>
					<%//if(user_id.equals("000096")||user_id.equals("000223")||user_id.equals("000231")){%>
					<br>
					<%if(AddUtil.parseDecimal(cons.getWash_card_amt()).equals("")||AddUtil.parseDecimal(cons.getWash_card_amt()).equals("0")){%>
					<a href="javascript:CardDocReg('<%=cons.getCar_no()%>','<%=j+1%>' , 'w');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
					<%}else{%>
					<a href="javascript:CardDocView('<%=cons.getCar_no()%>','<%=j+1%>', 'w');"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
					<%}%>
					<%//}%>
					</td>	
					<td align="center">
						<input type='text' name="wash_amt" value='<%=AddUtil.parseDecimal(cons.getWash_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'><br/>
						<%if(j==0){ %>
							<%if(file_name5.equals("")){%>
								<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','ws')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type5.equals("image/jpeg")||file_type5.equals("image/pjpeg")||file_type5.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type5%>','<%=seq5%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq5%>" target='_blank'><%=file_name5%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq5%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%}else if(j==1){ %>
							<%if(file_name6.equals("")){%>
								<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','ws')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type6.equals("image/jpeg")||file_type6.equals("image/pjpeg")||file_type6.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type6%>','<%=seq6%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq6%>" target='_blank'><%=file_name6%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq6%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%} %>	        		        
        		    </td>
        		   
        		    
        		    <td align="center"><input type='text' name="wash_fee" value='<%=AddUtil.parseDecimal(cons.getWash_fee())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>					
					<td align="center">
					
					<input type='text' name="oil_card_amt" value='<%=AddUtil.parseDecimal(cons.getOil_card_amt())%>' size='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'>
					<%//if(user_id.equals("000096")||user_id.equals("000223")||user_id.equals("000231")){%>
					<br>
					<%if(AddUtil.parseDecimal(cons.getOil_card_amt()).equals("")||AddUtil.parseDecimal(cons.getOil_card_amt()).equals("0")){%>
					<a href="javascript:CardDocReg('<%=cons.getCar_no()%>','<%=j+1%>', 'o');"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>
					<%}else{%>
					<a href="javascript:CardDocView('<%=cons.getCar_no()%>','<%=j+1%>', 'o');"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
					<%}%>
					<%//}%>
					</td>	
					
					<td align="center">
					<input type='text' name="oil_amt" value='<%=AddUtil.parseDecimal(cons.getOil_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'><br/>
						<%if(j==0){ %>
							<%if(file_name1.equals("")){%>
								<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','po')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%}else if(j==1){ %>
							<%if(file_name2.equals("")){%>
								<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','po')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
									<a href="javascript:openPopP('<%=file_type2%>','<%=seq2%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%} %>	

        		        <%if(!from_page.equals("/fms2/consignment_new/cons_oil_doc_frame.jsp") && (nm_db.getWorkAuthUser("전산팀",user_id)||user_id.equals(doc.getUser_id1())||user_id.equals(cons.getReq_id())) && cons.getOil_amt()>0 && cons.getM_doc_code().equals("")){%>
        		            <br><font color=red>[유류대경감요청공문</font><a href="javascript:M_doc_action('cons', '', '<%=cons.getCons_no()%>', '<%=cons.getSeq()%>', '<%=cons.getReq_id()%>', '1', '');" onMouseOver="window.status=''; return true" onfocus="this.blur()" title='유류대경감요청공문 기안하기'><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><font color=red>]</font>
        		        <%}%>
        		    </td>
        		    <td align="center"><input type='text' name="stot_amt" value='' size='6' class='whitenum'></td>	
        		       <td align="center"><input type='text' name="cons_other_amt" value='<%=AddUtil.parseDecimal(cons.getCons_other_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>				
        		    <td align="center">
					<input type='text' name="other_amt" value='<%=AddUtil.parseDecimal(cons.getOther_amt())%>' size='6' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);set_amt();'><br/>
					<%if(j==0){ %>
						<%if(file_name3.equals("")){%>
							<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','pk')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
						<%}else{%>
							<%if(file_type3.equals("image/jpeg")||file_type3.equals("image/pjpeg")||file_type3.equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=file_type3%>','<%=seq3%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq3%>" target='_blank'><%=file_name3%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq3%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}%>
					<%}else if(j==1){ %>
						<%if(file_name4.equals("")){%>
							<a href="javascript:scan_reg('<%=cons_no%>','<%=j+1%>','pk')" class="btn" title='스캔 첨부'> <img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
						<%}else{%>
							<%if(file_type4.equals("image/jpeg")||file_type4.equals("image/pjpeg")||file_type4.equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=file_type4%>','<%=seq4%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" border="0" align=absmiddle></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq4%>" target='_blank'><%=file_name4%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq4%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}%>
					<%} %>
					
					</td>
					
					<td align="center"><input type='text' name="etc1_amt"  <% if( nm_db.getWorkAuthUser("전산팀",user_id) || b_cons.getOff_id().equals("009217") ){%> <% } else { %> readonly <%} %> value='<%=AddUtil.parseDecimal(cons.getEtc1_amt())%>' size='5' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		    <td align="center"><input type='text' name="etc2_amt"  <% if( nm_db.getWorkAuthUser("전산팀",user_id) || b_cons.getOff_id().equals("009217") ){%> <% } else { %> readonly <%} %> value='<%=AddUtil.parseDecimal(cons.getEtc2_amt())%>' size='5' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
        		     							
        		    <td align="center"><input type='text' name="tot_amt" value='<%=AddUtil.parseDecimal(cons.getTot_amt())%>' size='6' class='whitenum'></td><!-- 법인카드제외  -->
        		    <td align="center"><input type='text' name="tot_dist" value='<%=AddUtil.parseDecimal(cons.getTot_dist())%>' size='7' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>km</td>					  
        		    <td align="center"><input type='text' name="cust_amt" value='<%=AddUtil.parseDecimal(cons.getCust_amt())%>' size='6' class='<%if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>default<%}else{%>white<%}%>num'></td>
        		    <td align="center"><input type='text' name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(cons.getCust_pay_dt())%>' size='11' class='<%if(cons.getCost_st().equals("2") && cons.getPay_st().equals("1")){%>default<%}else{%>whitetext<%}%>' onBlur='javascript:this.value=ChangeDate(this.value);'></td>
									
		        </tr>
		        <%}%>	
		        <tr>
        		    <td colspan="4" class='title'>합계</td>
        			<td class='title'><input type='text' name="cons_amt" value='' size='7' class='whitenum' readonly></td>
        		
        			<td class='title'><input type='text' name="wash_card_amt" value='' size='7' class='whitenum' readonly></td>
					<td class='title'><input type='text' name="wash_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="wash_fee" value='' size='7' class='whitenum' readonly></td>
					<td class='title'><input type='text' name="oil_card_amt" value='' size='7' class='whitenum' readonly></td>
					<td class='title'><input type='text' name="oil_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="stot_amt" value='' size='7' class='whitenum' readonly></td>					
        		    <!--<td class='title'>&nbsp;</td>-->
        		   	<td class='title'><input type='text' name="cons_other_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="other_amt" value='' size='7' class='whitenum' readonly></td>
        		   	<td class='title'><input type='text' name="etc1_amt" value='' size='7' class='whitenum' readonly></td>
        		   	<td class='title'><input type='text' name="etc2_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'><input type='text' name="tot_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'>&nbsp;</td>					
        		    <td class='title'><input type='text' name="cust_amt" value='' size='7' class='whitenum' readonly></td>
        		    <td class='title'>&nbsp;</td>
					
		        </tr>		  
		    </table>
	    </td>
    </tr>		
	<tr>
	    <td align="right">※ 2009년11월1일자 탁송부터는 정산시 차량 주행거리를 입력해야 합니다.</td>
	</tr>
					
	<%if(!b_cons.getOff_id().equals("003158")){%>
			
	<%if(doc.getUser_dt3().equals("") && (doc.getUser_id2().equals(user_id)||doc.getUser_id3().equals(user_id)||nm_db.getWorkAuthUser("탁송관리자",user_id))){%>
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('3');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absbottom" border="0"></a></td>
	</tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>					
	<%}%>
	
	<%if(!doc.getUser_dt3().equals("") && doc.getUser_dt4().equals("") && doc.getUser_id2().equals(user_id)){%>
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('u');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a></td>
	</tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>					
	<%}%>
	
	<%if(!doc.getUser_dt4().equals("") && doc.getUser_dt5().equals("") && (doc.getUser_id1().equals(user_id) || b_cons.getReg_id().equals(user_id) )){%>
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('u');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a></td>
	</tr>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>					
	<%}%>	
	
	
	<%}%>
	
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id)){%>	
	<tr>
	    <td align="center">&nbsp;<a href="javascript:doc_sanction('u');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>
	        <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:cons_delete('all','');"><img src="/acar/images/center/button_delete_all.gif" align="absbottom" border="0"></a>
	        <%}%>
	    </td>
	</tr>
	<tr>
	    <td align="right">&nbsp; </td>
	</tr>						
	<%}%>
	

	
	
	<%for(int j=0; j<b_cons.getCons_su(); j++){
		//탁송의뢰 1번
		ConsignmentBean 	cons 		= cs_db.getConsignment(cons_no, j+1);
		CarRegBean 		car 		= crd.getCarRegBean(cons.getCar_mng_id());
		ContCarBean 		car_etc 	= a_db.getContCarNew(cons.getRent_mng_id(), cons.getRent_l_cd());
		ClientBean 		client 		= al_db.getNewClient(cons.getClient_id());
		CarMstBean 		cm_bean 	= cmb.getCarNmCase(String.valueOf(car_etc.getCar_id()), String.valueOf(car_etc.getCar_seq()));
		
			//차량관리담당자 가져 올라고 
		ContBaseBean 	base	= a_db.getCont(cons.getRent_mng_id(), cons.getRent_l_cd());
		
		//탁송조회에서 차량정보를 못가져올경우(20190408)
		String car_nm = cm_bean.getCar_nm() + " " + cm_bean.getCar_name(); 
		if(car_nm.equals("")){		car_nm = car.getCar_nm();			}
		if(car_nm.equals("")){
			car 		= 		crd.getCarRegBean(base.getCar_mng_id());
			car_nm = car.getCar_nm();
		}
		if(car_nm.equals("")){
			car_nm = cmb.getCar_b_inc_name(car_etc.getCar_id(), car_etc.getCar_seq());
		}
		
		String to_dt = "";
		String get_to_dt = cons.getTo_dt();
		if(get_to_dt.equals("")) get_to_dt = cons.getTo_est_dt();
  		if(get_to_dt.length() == 12){
			to_dt 	= get_to_dt.substring(0,8);
		}
  		
  		String prev_car_no = cons.getCar_no();
		String car_no = "";
		if( prev_car_no.length() > 10 ) {
			car_no = cs_db.getCarNo(cons_no, j+1);
		}
		car_no = car_no == "" ? prev_car_no : car_no;
	%>
	<tr id=tr_cons<%=j%>_1 style="display:''">
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송<%=j+1%></span></td>
	</tr>
    <tr id=tr_cons<%=j%>_2 style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr><td class=line2 style='height:1'></td></tr>
                <tr> 
                    <td width='13%' class='title'>차량번호</td>
                    <td width='37%'>&nbsp;
        			  <input type='text' name="car_no" value='<%=car_no%>' size='30' class='<%=white%>text' readonly>
        			  <input type='hidden' name='seq' value='<%=cons.getSeq()%>'>
        			  <input type='hidden' name='car_mng_id' value='<%=cons.getCar_mng_id()%>'>
        			  <input type='hidden' name='rent_mng_id' value='<%=cons.getRent_mng_id()%>'>
        			  <input type='hidden' name='rent_l_cd' value='<%=cons.getRent_l_cd()%>'>
        			  <input type='hidden' name='client_id' value='<%=cons.getClient_id()%>'>
					  (<%=cons.getCar_mng_id()%>)
        			</td>
        			<td width='13%' class='title'>차명</td>
        			<td width='37%'>&nbsp;
        			  <%-- <input type='text' name="car_nm" value='<%=car.getCar_nm()%>' size='40' class='whitetext' readonly></td> --%>
        			  <input type='text' name="car_nm" value='<%=car_nm%>' size='40' class='whitetext' readonly></td>
                </tr>
    		    <tr>
        		    <td class='title'>연식</td>
        			<td>&nbsp;
        			  <input type='text' name="car_y_form" value='<%=car.getCar_y_form()%>' size='40' class='whitetext' readonly>
        			</td>
        		    <td class='title'>색상</td>
        			<td>&nbsp;
        			  <input type='text' name="color" value='<%=car_etc.getColo()%>' size='40' class='whitetext' readonly></td>			
    		    </tr>
    		    <tr>
        		    <td class='title'>기본사양</td>
        			<td colspan="3" >&nbsp;
        			  <textarea rows='5' cols='100' name='car_b' readonly><%=cm_bean.getCar_b()%></textarea>        			  
        			</td>
    		    </tr>    	
    		    <tr>
        		    <td class='title'>선택사양</td>
        			<td colspan="3" >&nbsp;
        			  <input type='text' name="opt" value='<%=car_etc.getOpt()%>' size='100' class='whitetext' readonly>
        			</td>
    		    </tr>    	     		    
    		    <tr>
        		    <td class='title'>고객명</td>
        			<td>&nbsp;
        			  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='70' class='whitetext' readonly>
        			</td>
        		<td class='title'>하이패스여부</td>
        			<td>&nbsp;
        				<select name="r_hipass_yn" disabled >
                        <option value=''>선택</option>
                        <option value='Y' <%if(car_etc.getHipass_yn().equals("Y"))%>selected<%%>>있음</option>
                        <option value='N' <%if(car_etc.getHipass_yn().equals("N"))%>selected<%%>>없음</option>
                      </select>
          			</td>	        			
					<!--
        		    <td class='title'>최종주행거리</td>
        			<td>&nbsp;
        			  	<%Hashtable b_ht = shDb.getCarDistView2(cons.getCar_mng_id(), to_dt);%>
						<%if(!String.valueOf(b_ht.get("TOT_DIST")).equals("")){%>
						<b><%=AddUtil.parseDecimal(String.valueOf(b_ht.get("TOT_DIST")))%>km (<%=AddUtil.ChangeDate2(String.valueOf(b_ht.get("TOT_DT")))%>)</b>
						<span class="b"><a href="javascript:view_car_service('<%=cons.getCar_mng_id()%>')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>							  
						<input type='hidden' name='v_tot_dist' value='<%=b_ht.get("TOT_DIST")%>'>
						<%}else{%>
						<input type='hidden' name='v_tot_dist' value=''>
						<%}%>						
        			</td>
					-->
    		    </tr>
    		</table>
	    </td>
    </tr>
	<tr id=tr_cons<%=j%>_3 style="display:''">
	    <td align="right">&nbsp;</td>
	</tr>	
    <tr id=tr_cons<%=j%>_4 style="display:''"> 
        <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        	<tr><td class=line2 style='height:1'></td></tr>		  
    		    <tr>
        		    <td colspan="2" class='title'>의뢰자</td>
        		    <td >&nbsp;
					<%if(cons.getReq_id().equals("")) cons.setReq_id(doc.getUser_id1());%>
        			  <select name='req_id' <%=disabled%>>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons.getReq_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%><%if(user.get("DEPT_ID").equals("1000")){%>[에이전트]<%}%></option>
                        <%		}
        					}%>
                      </select>
                      <%if(!cons.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(cons.getAgent_emp_id()); %>실 의뢰자 : <%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%><%}%>
        			</td>
        		    <td colspan="2" class='title'>탁송구간</td>
        		    <td >&nbsp;
        			  <select name="cmp_app" <%=disabled%>> 		
        			    <option value="">선택</option>
        			    	<%for(int i = 0 ; i < c_size2 ; i++){
        					Hashtable code2 = (Hashtable)codes2.elementAt(i);%>
        					<option value='<%=code2.get("NM_CD")%>' <%if(cons.getCmp_app().equals(String.valueOf(code2.get("NM_CD") ))){%>selected<%}%>><%=code2.get("NM")%></option>
        				<%}%>
 			  </select>
        			  <!--(자체탁송일때)-->
        			</td>					
    	        </tr>							
			<tr>
					<td colspan="2" class='title'>관리담당자</td>
					<td colspan="4">&nbsp;
						<select name='mng_id' <%=disabled%>>
							<option value="">선택</option>
							<%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
							<option value='<%=user.get("USER_ID")%>' <%if(base.getMng_id().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						  </select>
					</td>
				</tr>
		  <tr>
		    <td colspan="2" class='title'>탁송사유</td>
		    <td colspan="4">&nbsp;
			  <select name="cons_cau" onChange="javascript:cng_input4(this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
				<%for(int i = 0 ; i < c_size ; i++){
					CodeBean code = codes[i];	%>
				<option value='<%=code.getNm_cd()%>' <%if(cons.getCons_cau().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
				<%}%>
  			  </select>
			  &nbsp;기타사유 : <input type='text' name="cons_cau_etc" value='<%=cons.getCons_cau_etc()%>' size='40' class='<%=white%>text'>
			</td>
	      </tr>
		  <tr>
		    <td colspan="2" class='title'>비용구분</td>
			<td>&nbsp;
			  <select name="cost_st" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getCost_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getCost_st().equals("2")){%>selected<%}%>>고객</option>								
  			  </select>
			  <input type='hidden' name='cost_st2' value='<%=cons.getCost_st()%>'>
			<%if(cons.getCost_st().equals("2")){%><font color=red>고객</font><%}%>	  
			</td>						
		    <td colspan="2" class='title'>지급구분</td>
			<td>&nbsp;
			  <select name="pay_st" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getPay_st().equals("1")){%>selected<%}%>>선불</option>
			    <option value="2" <%if(cons.getPay_st().equals("2")){%>selected<%}%>>후불</option>								
  			  </select>
			  <input type='hidden' name='pay_st2' value='<%=cons.getPay_st()%>'>
			</td>						
	      </tr>
		  <tr>
		    <td rowspan="4" class='title'>요<br>
	        청</td>
		    <td class='title'>세차</td>
		    <td colspan="4">&nbsp;
			  <select name="wash_yn" <%=disabled%>>
			    <option value="">선택</option>
			    <%-- <option value="Y" <%if(cons.getWash_yn().equals("Y")){%>selected<%}%>>요청</option> --%>
			    <option value="M" <%if(cons.getWash_yn().equals("M")||cons.getWash_yn().equals("Y")){%>selected<%}%>>기계세차</option>
   			    <option value="H" <%if(cons.getWash_yn().equals("H")){%>selected<%}%>>손세차</option>
			    <option value="N" <%if(cons.getWash_yn().equals("N")){%>selected<%}%>>없음</option>								
  			  </select>
			</td>
	      </tr>
		  <tr>
		    <td class='title'>주유</td>
		    <td colspan="4">&nbsp;
			  <select name="oil_yn" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="Y" <%if(cons.getOil_yn().equals("Y")){%>selected<%}%>>요청</option>
			    <option value="N" <%if(cons.getOil_yn().equals("N")){%>selected<%}%>>없음</option>								
  			  </select>
				주유요청시 -&gt; 
			  <input type='text' name="oil_liter" value='<%=Util.parseDecimal(cons.getOil_liter())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
				리터<!--ℓ--> 
				혹은
			  <input type='text' name="oil_est_amt" value='<%=Util.parseDecimal(cons.getOil_est_amt())%>' size='11' class='<%=white%>num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
				원어치 주유 해주세요.</td>
	      </tr>
    		    <tr>
        		    <td class='title'>하이패스등록</td>
        		    <td colspan="4">&nbsp;
        		    	<%if(disabled.equals("disabled")){%>        		    	          		    	  
        		    	  <%if(cons.getHipass_yn().equals("Y")){%><font color='red'><b>요청</b></font><%}%>
        		    	  <%if(cons.getHipass_yn().equals("N")){%>없음<%}%>
        		    	  
        		    	<%}else{%>
        			  <select name="hipass_yn" <%=disabled%>>
        			    <option value="Y" <%if(cons.getHipass_yn().equals("Y")){%>selected<%}%>>요청</option>
        			    <option value="N" <%if(cons.getHipass_yn().equals("N")||cons.getHipass_yn().equals("")){%>selected<%}%>>없음</option>								
          			  </select>
					  (등록대행 의뢰시 선택하십시오.)        		    	  
        		    	<%}%>
        		    </td>
    	        </tr>					  
		  <tr>
		    <td class='title'>기타</td>
		    <td colspan="4">&nbsp;
              <textarea rows='5' cols='90' name='etc' class='<%=white%>'><%=cons.getEtc()%></textarea></td>
	      </tr>		  
		  <tr>
		    <td width="3%" rowspan="7" class='title'>출<br>발</td>
		    <td width="10%" class='title'>구분</td>
		    <td width="37%">&nbsp;
			  <select name="from_st" onChange="javascript:cng_input3('from', this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getFrom_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getFrom_st().equals("2")){%>selected<%}%>>고객</option>
			    <option value="3" <%if(cons.getFrom_st().equals("3")){%>selected<%}%>>협력업체</option>
			    <option value="4" <%if(cons.getFrom_st().equals("4")){%>selected<%}%>>신차출발</option>				
  			  </select>
			  <%if(white.equals("")){%>		
			  <span class="b"><a href="javascript:cng_input3('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		    <td width="3%" rowspan="7" class='title'>도<br>착</td>
		    <td width="10%" class='title'>구분</td>
		    <td width="37%">&nbsp;
			  <select name="to_st" onChange="javascript:cng_input3('to', this.value, <%=j%>)" <%=disabled%>>
			    <option value="">선택</option>
			    <option value="1" <%if(cons.getTo_st().equals("1")){%>selected<%}%>>아마존카</option>
			    <option value="2" <%if(cons.getTo_st().equals("2")){%>selected<%}%>>고객</option>
			    <option value="3" <%if(cons.getTo_st().equals("3")){%>selected<%}%>>협력업체</option>				
  			  </select>
			  <%if(white.equals("")){%>			
			  <span class="b"><a href="javascript:cng_input3('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>			
		  </tr>
		  <tr>
		    <td width="10%" class='title'>장소</td>
		    <td>&nbsp;
                <input type='text' name="from_place" id="from_place" value='<%=cons.getFrom_place()%>' size='40' class='<%=white%>text' ></td>
		    <td width="10%" class='title'>장소</td>
		    <td>&nbsp;
                <input type='text' name="to_place" value='<%=cons.getTo_place()%>' size='40' class='<%=white%>text' ></td>
		  </tr>
		  <tr>
		    <td class='title'>상호/성명</td>
		    <td>&nbsp;
                <input type='text' name="from_comp" id="from_comp" value='<%=cons.getFrom_comp()%>' size='40' class='<%=white%>text' >
				</td>
		    <td class='title'>상호/성명</td>
		    <td>&nbsp;
                <input type='text' name="to_comp" value='<%=cons.getTo_comp()%>' size='40' class='<%=white%>text' ></td>
		  </tr>
		  <tr>
		    <td class='title'>담당자</td>
	        <td>&nbsp;부서/직위
	          <input type='text' name="from_title" id="from_title" value='<%=cons.getFrom_title()%>' size='20' class='<%=white%>text' ><br>
              &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type='text' name="from_man" id="from_man" value='<%=cons.getFrom_man()%>' size='20' class='<%=white%>text' >
			  <%if(white.equals("")){%>
			  <span class="b"><a href="javascript:cng_input5('from', document.form1.from_st[<%=j%>].options[document.form1.from_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		    <td class='title'>담당자</td>
		    <td>&nbsp;부서/직위
		      <input type='text' name="to_title" value='<%=cons.getTo_title()%>' size='13' class='<%=white%>text' ><br>
			  &nbsp;성명&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type='text' name="to_man" value='<%=cons.getTo_man()%>' size='13' class='<%=white%>text' >
			  <%if(white.equals("")){%>
			  <span class="b"><a href="javascript:cng_input5('to', document.form1.to_st[<%=j%>].options[document.form1.to_st[<%=j%>].selectedIndex].value, <%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요">조회</a></span>
			  <%}%>
			</td>
		  </tr>
		  <tr>
		    <td class='title'>연락처</td>
		    <td>&nbsp;사무실
                <input type='text' name="from_tel" id="from_tel" value='<%=cons.getFrom_tel()%>' size='15' class='<%=white%>text' ><br>
				&nbsp;핸드폰
                <input type='text' name="from_m_tel" id="from_m_tel" value='<%=cons.getFrom_m_tel()%>' size='15' class='<%=white%>text' >
			</td>
		    <td class='title'>연락처</td>
		    <td>&nbsp;사무실
                <input type='text' name="to_tel" value='<%=cons.getTo_tel()%>' size='15' class='<%=white%>text' ><br>
				&nbsp;핸드폰
                <input type='text' name="to_m_tel" value='<%=cons.getTo_m_tel()%>' size='15' class='<%=white%>text' >
			</td>
		  </tr>
		  <tr>
		    <td class='title'>요청일시</td>
		    <td>&nbsp;
			  <%	String from_req_dt = "";
			  		String from_req_h = "";
					String from_req_s = "";
			  		if(cons.getFrom_req_dt().length() == 12){
						from_req_dt = cons.getFrom_req_dt().substring(0,8);
						from_req_h 	= cons.getFrom_req_dt().substring(8,10);
						from_req_s	= cons.getFrom_req_dt().substring(10,12);
					}%>
              <input type='text' name="from_req_dt" value='<%=AddUtil.ChangeDate2(from_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_req_dt[<%=j%>].value=this.value;'>
              &nbsp;
			  <select name="from_req_h" onchange="javascript:document.form1.to_req_h[<%=j%>].value=this.value;" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="from_req_s" onchange="javascript:document.form1.to_req_s[<%=j%>].value=this.value;" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
            </td>
		    <td class='title'>요청일시</td>
		    <td>&nbsp;
			  <%	String to_req_dt = "";
			  		String to_req_h = "";
					String to_req_s = "";
			  		if(cons.getTo_req_dt().length() == 12){
						to_req_dt 	= cons.getTo_req_dt().substring(0,8);
						to_req_h 	= cons.getTo_req_dt().substring(8,10);
						to_req_s 	= cons.getTo_req_dt().substring(10,12);
					}%>			
              <input type='text' name="to_req_dt" value='<%=AddUtil.ChangeDate2(to_req_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value)'>
              &nbsp;
			  <select name="to_req_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="to_req_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_req_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
            </td>
	      </tr>
		  <tr>
		    <td class='title'>예정일시</td>
		    <td>&nbsp;
			  <%	String from_est_dt = "";
			  		String from_est_h = "";
					String from_est_s = "";
			  		if(cons.getFrom_est_dt().length() == 12){
						from_est_dt = cons.getFrom_est_dt().substring(0,8);
						from_est_h 	= cons.getFrom_est_dt().substring(8,10);
						from_est_s	= cons.getFrom_est_dt().substring(10,12);
					}%>			
              <input type='text' name="from_est_dt" value='<%=AddUtil.ChangeDate2(from_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value); document.form1.to_est_dt[<%=j%>].value=this.value;'>
			  &nbsp;
			  <select name="from_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="from_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(from_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
	        <td class='title'>예정일시</td>
	        <td>&nbsp;
			  <%	String to_est_dt = "";
			  		String to_est_h = "";
					String to_est_s = "";
			  		if(cons.getTo_est_dt().length() == 12){
						to_est_dt 	= cons.getTo_est_dt().substring(0,8);
						to_est_h 	= cons.getTo_est_dt().substring(8,10);
						to_est_s 	= cons.getTo_est_dt().substring(10,12);
					}%>						
              <input type='text' name="to_est_dt" value='<%=AddUtil.ChangeDate2(to_est_dt)%>' size='11' class='<%=white%>text' onBlur='javascript:this.value=ChangeDate(this.value);'>
			  &nbsp;
			  <select name="to_est_h" <%=disabled%>>
                <%for(int i=0; i<24; i++){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_h.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                <%}%>
              </select>
              <select name="to_est_s" <%=disabled%>>
                <%for(int i=0; i<59; i+=5){%>
                <option value="<%=AddUtil.addZero2(i)%>" <%if(to_est_s.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                <%}%>
              </select>
			  </td>
		  </tr>
		  <%	String driver_nm = cons.getDriver_nm();
		  		if(cons.getOff_id().equals("003158")) driver_nm = c_db.getNameById(cons.getDriver_nm(),"USER");%>
		  <tr>
		    <td colspan="2" class='title'>운전자명</td>
            <td>&nbsp;
                <input type='text' name="driver_nm" value='<%=driver_nm%>' size='15' class='default'>
				<input type='hidden' name="driver_id" value='<%=cons.getDriver_nm()%>'>
				&nbsp;<span class="b"><a href="javascript:cng_input6('driver','3',<%=j%>)" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif" align="absbottom" border="0"></a></a></span>
			</td>
            <td colspan="2" class='title'>운전자핸드폰</td>
            <td>&nbsp;
                <input type='text' name="driver_m_tel" value='<%=cons.getDriver_m_tel()%>' size='15' class='default'></td>
	      </tr>		  
        </table>
      </td>
    </tr>	
	<tr id=tr_cons<%=j%>_5 style="display:''">
	  <td align="right">
	    <%if(doc.getUser_id1().equals(user_id) || b_cons.getReg_id().equals(user_id)){%>
	    <%		if(!doc.getUser_dt5().equals("")){}else{%>		
<%-- 		<a href="javascript:save(<%=j%>);"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>	 --%>
		<%		}%>
		<%}else{%>
		<%		if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%>
<%-- 		<a href="javascript:save(<%=j%>);"><img src="/acar/images/center/button_modify.gif" align="absbottom" border="0"></a>	 --%>
		&nbsp;<a href="javascript:cons_delete('all','');"><img src="/acar/images/center/button_delete_all.gif" align="absbottom" border="0"></a>
		<%		}%>
		<%}%>
	    &nbsp;<a href="javascript:ConsPrint(<%=cons.getSeq()%>)"><img src="../../images/printer.gif" border="0"></a></td>
	</tr>		
	<%}%>			
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>		
	<%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	<!--
	<tr>
	  <td align="right">&nbsp;<a href="cons_reg_step1.jsp?cons_no=<%=cons_no%>"><img src="/acar/images/center/button_el.gif" align="absbottom" border="0"></a>&nbsp;&nbsp;<a href="cons_reg_step2.jsp?cons_no=<%=cons_no%>"><img src="/acar/images/center/button_sus.gif" align="absbottom" border="0"></a>&nbsp;&nbsp;<a href="cons_reg_step3.jsp?cons_no=<%=cons_no%>"><img src="/acar/images/center/button_js.gif" align="absbottom" border="0"></a>&nbsp;&nbsp;<a href="cons_reg_step4.jsp?cons_no=<%=cons_no%>"><img src="/acar/images/center/button_sh.gif" align="absbottom" border="0"></a></td>
	</tr>			
	-->
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	set_amt();
//-->
</script>
</body>
</html>
