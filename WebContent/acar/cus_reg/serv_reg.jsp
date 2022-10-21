<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.accid.*,acar.client.*, acar.common.*, acar.cus_reg.*, acar.car_service.*, acar.serv_off.*, acar.pay_mng.*, acar.doc_settle.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");  //cmd:4(사고에서 자차정비등록)
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String go_url = request.getParameter("go_url")==null?"N":request.getParameter("go_url");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int result=0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	CarInfoBean carinfoBn = cr_db.getCarInfo(car_mng_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//로그인정보
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String dept_id = login.getDept_id(user_id);
	
	if(rent_mng_id.equals("")||rent_l_cd.equals("")){
		Hashtable ht = c_db.getRent_id(car_mng_id);
		rent_mng_id = (String)ht.get("RENT_MNG_ID")==null?"":(String)ht.get("RENT_MNG_ID");
		rent_l_cd 	= (String)ht.get("RENT_L_CD")==null?"":(String)ht.get("RENT_L_CD");
	}
	
	//정비코드가 없으면 다음 정비코드 조회
	if(serv_id.equals("") && !accid_id.equals("")){
		serv_id = cr_db.getServ_id(car_mng_id);
		result = cr_db.insertService(car_mng_id, serv_id, accid_id, rent_mng_id, rent_l_cd, ck_acar_id);
	}
	if(serv_id.equals("")){
		serv_id = cr_db.getServ_id(car_mng_id);
	}
	
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
	String file_path="";
	if(!siBn.getRent_mng_id().equals("")){
		rent_mng_id 	= siBn.getRent_mng_id();
		rent_l_cd 	= siBn.getRent_l_cd();
		accid_id 	= siBn.getAccid_id();
		file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(siBn.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");                		      
	}
	
		
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//출금원장
	Hashtable serv_pay = ps_db.getPayServ(car_mng_id, serv_id);
	String serv_reg_st = (String)serv_pay.get("SERV_REG_ST")==null?"":(String)serv_pay.get("SERV_REG_ST");
	
	//카드결재
	Hashtable serv_card = ps_db.getCardServ(car_mng_id, serv_id);
	String card_buy_dt = (String)serv_card.get("BUY_DT")==null?"":(String)serv_card.get("BUY_DT");
	
	//점검자,점검일 디폴트세팅
	if(siBn.getChecker().equals(""))	siBn.setChecker(user_id);
	if(siBn.getSpdchk_dt().equals("")&& AddUtil.parseInt(siBn.getServ_dt())>20040801)	siBn.setSpdchk_dt(Util.getDate());
	
	//순회점검-speedcheck
	SpdchkBean spdchk = new SpdchkBean();
	CarInfoBean ci_bean = new CarInfoBean();
	if(rent_l_cd.equals("")){
		ci_bean = cr_db.getCarInfo(car_mng_id);
	}else{
		ci_bean = cr_db.getCarInfo(car_mng_id, rent_l_cd);
	}
	
	SpdchkBean[] spdchks = cr_db.getSpdchk();
	
	String[] seq = null;
	int	x=0,y=0,z = 0;
	if(!siBn.getSpd_chk().equals("")){
		Vector vt = new Vector();
		StringTokenizer st = new StringTokenizer(siBn.getSpd_chk(),"/");
		int k = 0;
		seq = new String[st.countTokens()];
		while(st.hasMoreTokens()){
			seq[k] = st.nextToken();
			if(seq[k].substring(0,1).equals("1")){
				x++;
			}else if(seq[k].substring(0,1).equals("2")){
				y++;
			}else if(seq[k].substring(0,1).equals("3")){
				z++;
			}
			k++;
		}
	}
			
	if(siBn.getOff_id().equals("")){
		if(user_id.equals("000047")){		//명진공업사
			so_bean = sod.getServOff("000620");
		}else if(user_id.equals("000081")){	//동부카독크
			so_bean = sod.getServOff("001960");
		}else if(user_id.equals("000106")){	//부경자동차정비
			so_bean = sod.getServOff("002105");
		}else if(user_id.equals("000173")){	//삼일정비
			so_bean = sod.getServOff("001816");
		}else if(user_id.equals("000112")){	//현대카독크대전
			so_bean = sod.getServOff("002734");
		}else if(user_id.equals("000143")){	//정일현대자동차정비공업
			so_bean = sod.getServOff("000286");
		}else if(user_id.equals("000171")){	//대전노블레스
			so_bean = sod.getServOff("007603");
		}else if(user_id.equals("000195")){	//1급금호-대전
			so_bean = sod.getServOff("007897");
		}else if(user_id.equals("000200")){	//광주:상무현대정비
			so_bean = sod.getServOff("008507");
		}else if(user_id.equals("000198")){	//대구:(주)성서현대정비센터
			so_bean = sod.getServOff("008462");
		}else if(user_id.equals("000210")){	//광주:(주)옥산자동차공업사
			so_bean = sod.getServOff("008611");	
		}else if(user_id.equals("000334")){	//강서:아마존모터스
			so_bean = sod.getServOff("012005");
		}
		siBn.setOff_id(so_bean.getOff_id());
		siBn.setOff_nm(so_bean.getOff_nm());
	}
	
	Serv_ItemBean[] siIBns = cr_db.getServ_item(car_mng_id, serv_id, "asc");
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettleCommi("41", car_mng_id+""+serv_id);
	String doc_no = doc.getDoc_no();
	
	//재리스수리비는 최초영업자로
	String bus_id2 =  "";
	
//	bus_id2 =  base.getBus_id2();  // 현시점의 영업담당자
					
	if ( !siBn.getBus_id2().equals("")){
	 	bus_id2 = siBn.getBus_id2();		
	} 
		
//	out.println(siBn.getSup_amt());
			
	String accid_dt = "";
			
	 //사고조회
	AccidentBean a_bean = as_db.getAccidentBean(car_mng_id, accid_id);		
	
	if (  !a_bean.getAccid_dt().equals("")) {
		accid_dt = a_bean.getAccid_dt().substring(0,8);
	}
	
   //구조장치
    Hashtable car_cha = cr_db.getCar_cha(car_mng_id, serv_id);    
	int b_dist = 0;
	b_dist = AddUtil.parseInt((String)car_cha.get("B_DIST"));

	String today_dt = AddUtil.getDate(4);	
		
//	out.println(b_dist);
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	var popObj = null;
	
	function MM_openBrWindow3(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/<%=file_path%>"+theURL+".pdf";
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
		file_down_history();	
	}
	
		function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();

	}
		
		//자동차 조회
	function search_car()
	{
			var fm = document.form1;
			window.open("/tax/pop_search/s_car.jsp?go_url=/acar/cus_reg/serv_reg.jsp&s_kd=2&t_wd="+fm.car_no.value, "CAR", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}			
	
	function view_map(file_path, scan){
		var map_path = scan;
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/"+file_path+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes, scrollbars=yes, status=yes");
	}
	
	//디스플레이 타입-정비분류
	function cng_display2(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.rep_amt.value)) > 0 &&  fm.serv_st.value == '1' ) {	
			alert("순회점검으로 입력할 수 없습니다.!");	
			fm.serv_st.value = "";
			fm.serv_st.focus(); 
			return;
		}
		
		if(fm.serv_st.options[fm.serv_st.selectedIndex].value == '1'||
			fm.serv_st.options[fm.serv_st.selectedIndex].value == ''){
			spdchk.style.display = '';
			general.style.display = 'none';
		}else if((fm.x.value>0)&&(fm.serv_st.options[fm.serv_st.selectedIndex].value=='2'||fm.serv_st.options[fm.serv_st.selectedIndex].value=='3')){
			spdchk.style.display = 'none';
			general.style.display = '';
		}else if(fm.serv_st.options[fm.serv_st.selectedIndex].value=='4'||fm.serv_st.options[fm.serv_st.selectedIndex].value=='5'){
			spdchk.style.display = 'none';
			general.style.display = '';
		}else{
			//alert("순회점검사항을 체크하셔야 일반정비나\n보증정비내역을 입력할 수 있습니다!!");
		}
		
		
	}	

function regRound(){
	var fm = document.form1;
	
	if(fm.serv_st.value=="" || fm.serv_st.value=="4"  || fm.serv_st.value=="5" ){			alert("정비구분을 선택해 주세요!");		fm.serv_st.focus(); 	return; }
//	if(fm.serv_st.value=="")		{	alert("정비분류를 선택해 주세요!");		fm.serv_st.focus(); 		return; }
	if(fm.checker.value=="")		{	alert("점검자를 선택해 주세요!");		fm.checker.focus(); 		return; }
	if(fm.checker_st.value=="")		{	alert("시행자를 선택해 주세요!");		fm.checker_st.focus(); 		return; }
	if(fm.spdchk_dt.value=="")		{	alert("순회점검일을 입력해 주세요!");	fm.spdchk_dt.focus(); 		return; }
	if (!checkDate('순회점검일', replaceString("-","",fm.spdchk_dt.value))){	alert("순회점검일 확인해 주세요!");	fm.spdchk_dt.focus(); return; }	
	if(toInt(fm.tot_dist.value)==0)	{	alert("실주행거리를 입력해 주세요!");	fm.tot_dist.focus(); 		return; }
	if(fm.next_serv_dt.value=="")	{	alert("다음점검일을 입력해 주세요!"); 	fm.next_serv_dt.focus(); 	return; }
	if (!checkDate('다음점검일', replaceString("-","",fm.next_serv_dt.value))){	alert("다음점검일 확인해 주세요!");	fm.next_serv_dt.focus(); return; }
		
//	if(fm.rep_cont.value=="")		{	alert("조치내용을 입력해 주세요!");		fm.rep_cont.focus(); 		return; }
	
	if(!confirm('순회점검을 등록 하시겠습니까?')){ return; }
	fm.action = "/acar/cus_reg/round_ins.jsp";
	fm.target = "i_no";
	fm.submit();
}

function regGeneral(){
	var fm = document.form1;
	
	if(fm.serv_st.value=="" || fm.serv_st.value=="4"  || fm.serv_st.value=="5" ){			alert("정비구분을 선택해 주세요!");		fm.serv_st.focus(); 	return; }
		 	 	
//	if(fm.serv_st.value=="")		{	alert("정비분류를 선택해 주세요!");		fm.serv_st.focus(); 		return; }
	if(fm.checker.value=="")		{	alert("점검자를 선택해 주세요!");		fm.checker.focus(); 		return; }
	if(fm.spdchk_dt.value=="")		{	alert("점검일을 입력해 주세요!");		fm.spdchk_dt.focus(); 		return; }
	if(toInt(fm.tot_dist.value)==0)	{	alert("실주행거리를 입력해 주세요!");	fm.tot_dist.focus(); 		return; }
	if(fm.serv_dt.value=="")		{	alert("정비일자를 입력해 주세요!");		fm.serv_dt.focus(); 		return; }
	if (!checkDate('정비일자', replaceString("-","",fm.serv_dt.value))){	alert("정비일자 확인해 주세요!");	fm.serv_dt.focus(); return; }
	if(fm.off_nm.value=="")			{	alert("정비업체를 선택해 주세요!");		fm.off_nm.focus(); 			return; }
	
	<%if (serv_reg_st.equals("Y")){ %>
	if(fm.ipgodt.value=="")		{	fm.ipgodt.value 	= fm.serv_dt.value; }
	if(fm.chulgodt.value=="")	{	fm.chulgodt.value = fm.serv_dt.value; }
	<%}%>

	if(fm.ipgodt.value==""){			alert("입고일자를 입력해 주세요!");		fm.ipgodt.focus(); 		return; }				
	
	if(fm.chulgodt.value==""){			alert("출고일자를 입력해 주세요!");		fm.chulgodt.focus(); 		return; }		
	
	//재리스정비인 경우 아마존카고객인 경우 입력못하게 막음 - 20161025
	if ( fm.serv_st.value  == '7' ) {  //아마존카 보유차로 선택시 
	   <% if (base.getClient_id().equals("000228") ) { %>
	          alert("재리스정비입니다. 해당 계약을 선택하여 등록하십시요. 사고등록이 있는경우 해당사고를 삭제후 다시 입력하세요.!!!!");	  	   
	          return;
	   <% } %> 	
	}

	
		//해지정비인 경우 아마존카고객인 경우 입력못하게 막음 - 20161025
	if ( fm.serv_st.value  == '12' ) {  //아마존카 보유차로 선택시 
	   <% if (base.getClient_id().equals("000228") ) { %>
	          alert("해지정비입니다. 해당 계약을 선택하여 등록하십시요. 사고등록이 있는경우 해당사고를 삭제후 다시 입력하세요.!!!!");	  	   
	          return;
	   <% } %> 	
	} 
		
		
	//명진 정비건은 수정못함 (정산 후)
	<% if (!nm_db.getWorkAuthUser("보유차관리자들",user_id)  &&  !nm_db.getWorkAuthUser("전산팀",user_id) ) { %>    
	//	if(fm.off_id.value == '000620' || fm.off_id.value == '002105'  || fm.off_id.value == '002734' || fm.off_id.value == '000286' || fm.off_id.value == '006858'  || fm.off_id.value == '001816' || fm.off_id.value == '007897' || fm.off_id.value == '008462' || fm.off_id.value == '008507' || fm.off_id.value == '008611' || fm.off_id.value == '010779'  ){	
			if(fm.jung_st.value != "")		{	alert("정산이완료된건입니다. 수정할 수 없습니다.!");		return; }
	//	}
	<% } %>
	
	//출금약식등록일 경우 금액변동 안됨 ->정산완료처리되어 수정막아짐.!nm_db.getWorkAuthUser("면책금관리자",user_id)
	<% if (!nm_db.getWorkAuthUser("전산팀",user_id) && !nm_db.getWorkAuthUser("본사관리팀총무",user_id) && !nm_db.getWorkAuthUser("정비출금등록자",user_id)) { %>    
	<%    if (serv_reg_st.equals("Y")){ %>
					if(toInt(parseDigit(fm.tot_amt.value)) > <%=serv_pay.get("I_AMT")%> || toInt(parseDigit(fm.tot_amt.value)) < <%=serv_pay.get("I_AMT")%>){ 		
						alert("출금약식등록일 경우 출금원장금액과 틀릴수는 없습니다."); 	fm.tot_amt.focus(); 	return; 
					}
	<%    } else {%>	
	    		if(fm.jung_st.value != ""){	
	    			alert("정산이완료된건입니다. 수정할 수 없습니다.!");	return; 
	    		}
	<%    }%>	
	<% } %>
		
	if(fm.serv_st.value=="2"   ||  fm.serv_st.value=="4" ||  fm.serv_st.value=="5" ||  fm.serv_st.value=="7"  || fm.serv_st.value=="11"  ||  fm.serv_st.value=="12"  )	{
			if( fm.sup_amt.value == "0" )	{ alert(" 공급가 금액을 확인해주세요!");		return; } 
		     	if( fm.add_amt.value == "0" )	{ alert(" 부가세 금액을 확인해주세요!");		return; } 
		     	if( fm.rep_amt.value == "0" )	{ alert(" 정비금액을 확인해주세요!");		return; } 
		     	if( fm.tot_amt.value == "0" )	{ alert(" 지급금액을 확인해주세요!");		return; } 
	}
		   
   	//청구부가세액이 10% 여부 확인 
 	vat_chk_amt 	=toInt( toInt(parseDigit(fm.sup_amt.value)) * 0.1  -   toInt(parseDigit(fm.add_amt.value))) ;
	 //	alert(Math.abs(vat_chk_amt));	
	if  (Math.abs(vat_chk_amt) > 100 ) {
	 	 alert("부가세액을 확인하세요!!");
	 	 return;
	}
		   	
    	 if(fm.serv_st.value == '1' || fm.serv_st.value == '2'  || fm.serv_st.value == '3' ){	
    	        
    	 	if ( fm.bus_id2.value == '' ) {
    	 	    fm.bus_id2.value = '<%= base.getBus_id2()%>';
    	 	}
    	 }
    	     
    	 if( toInt(parseDigit(fm.item_sum.value)) < 1   &&  toInt(parseDigit(fm.rep_amt.value)) > 0  )	{ alert(" 정비항목을  확인해주세요!");		return; } 	
    	 	
    	var a_dt = replaceString("-","",fm.accid_dt.value);
 		var s_dt = replaceString("-","",fm.serv_dt.value);
 		var i_dt = replaceString("-","",fm.ipgodt.value);
 		var c_dt = replaceString("-","",fm.chulgodt.value);
 		 		 		
 		 //사고일자보다 정비일자가 클 수 없다
 		if(s_dt < a_dt){ alert("사고일자가 정비일자보다 클 수 없습니다.\n\n정비일자를 확인하십시오."); return; }		
 		 		
 		if(i_dt < a_dt){ alert("사고일자가 입고일자보다 클 수 없습니다.\n\n입고일자를 확인하십시오."); return; }		
 		 		
 		if(c_dt < a_dt){ alert("사고일자가 출고일자보다 클 수 없습니다.\n\n출고일자를 확인하십시오."); return; }			
 		
 		 	// 금일날짜보다 클 수 없다.
		if(s_dt > <%=today_dt%>){ alert('정비일자가 금일보다  클 수 없습니다.\n\n정비일자를 확인하십시오.'); return; }			
				
		if(i_dt > <%=today_dt%>){ alert('입고일자가 금일보다 클 수 없습니다.\n\n입고일자를 확인하십시오.'); return; }	
	
		if(c_dt > <%=today_dt%>){ alert('출고일자가 금일보다 클 수 없습니다.\n\n출고일자를 확인하십시오.'); return; }	
	 		
		if(!confirm('입력한 정비내역을 등록 하시겠습니까?')){ return; }
		fm.action = "/acar/cus_reg/general_ins.jsp";
		fm.target = "i_no";
		fm.submit();
}

function delServ(){
		var fm = document.form1;	
	
		if(!confirm('삭제하시겠습니까?')){
			return;
		}		
		fm.action = "/acar/accid_mng/accid_gu_a.jsp?wk_st=servdel"
		fm.target = "i_no"
		fm.submit();

	}	
	
	
function regGen(){
	var fm = document.form1;	
	
	if(fm.serv_st.value=="" || fm.serv_st.value=="4"  || fm.serv_st.value=="5" ){			alert("정비구분을 선택해 주세요!");		fm.serv_st.focus(); 	return; }	
//	if(fm.serv_st.value=="")		{	alert("정비분류를 선택해 주세요!");		fm.serv_st.focus(); 		return; }
   	
   	if(toInt(parseDigit(fm.rep_amt.value)) > 0 &&  fm.serv_st.value == '1' ) {	alert("순회점검으로 입력할 수 없습니다.!");	fm.serv_st.focus(); return; }
   	
   	//중고차인 경우  아마존카 재리스정비 허용 -20161229 
   	 
<% if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) { %>
<%} else {%>
	   		//재리스정비인 경우 아마존카고객인 경우 입력못하게 막음 - 20161025
		if ( fm.serv_st.value  == '7' ) {  //아마존카 보유차로 선택시 
		   <% if (base.getClient_id().equals("000228") ) { %>
		          alert("재리스정비입니다. 해당 계약을 선택하여 등록하십시요. 사고등록이 있는경우 해당사고를 삭제후 다시 입력하세요.!!!!");	  	   
		                return;
		   <% } %> 	
		} 
<% } %>   	    	 

   		//해지정비인 경우 아마존카고객인 경우 입력못하게 막음 - 20161025
	if ( fm.serv_st.value  == '12' ) {  //아마존카 보유차로 선택시 
	   <% if (base.getClient_id().equals("000228") ) { %>
	          alert("해지정비입니다. 해당 계약을 선택하여 등록하십시요. 사고등록이 있는경우 해당사고를 삭제후 다시 입력하세요.!!!!");	  	 
	           return;  
	   <% } %> 	
	}     	 
  
   	 	 //명진 정비건은 수정못함 (정산 후)
	<% if (!nm_db.getWorkAuthUser("본사관리팀장",user_id)  &&  !nm_db.getWorkAuthUser("전산팀",user_id) ) { %>    
	 
	if(fm.off_id.value == '000620' || fm.off_id.value == '002105'  || fm.off_id.value == '002734' || fm.off_id.value == '000286' || fm.off_id.value == '006858'  || fm.off_id.value == '001816' || fm.off_id.value == '007897' || fm.off_id.value == '008462' || fm.off_id.value == '008507' || fm.off_id.value == '008611'  || fm.off_id.value == '010779' || fm.off_id.value == '008634' || fm.off_id.value == '000092' ){	
		if(fm.jung_st.value != "")		{	alert("정산이완료된건입니다. 수정할 수 없습니다.!");		return; }
	}
	<% } %>	
   	 
	if(!confirm('정비분류를 수정하시겠습니까?')){ return; }
	
	fm.action = "/acar/cus_reg/gen_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}


function regGen1(){
	var fm = document.form1;	
	
	if(fm.serv_st.value=="" || fm.serv_st.value=="4"  || fm.serv_st.value=="5" ){			alert("정비구분을 선택해 주세요!");		fm.serv_st.focus(); 	return; }	
   	
   	if(toInt(parseDigit(fm.rep_amt.value)) > 0 &&  fm.serv_st.value == '1' ) {	alert("순회점검으로 입력할 수 없습니다.!");	fm.serv_st.focus(); return; }
   	
//   	if(fm.jung_st.value != "")		{	alert("정산이완료된건입니다. 수정할 수 없습니다.!");		return; }
   	
   	    	 
	if(!confirm('사고종결건 정비분류를 수정하시겠습니까?')){ return; }
	
	fm.action = "/acar/cus_reg/gen_upd.jsp";
	fm.target = "i_no";
	fm.submit();
}

//팝업윈도우 열기
function MM_openBrWindow2(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}	

function serv_off_open(){
	var fm = document.form1;
	fm.off_id.value = '';
	fm.off_nm.value = '';
	fm.ent_no.value =  '';
	fm.own_nm.value =  '';
	fm.off_st.value =  '';
	fm.off_addr.value =  '';
	fm.off_tel.value =  '';
	fm.off_fax.value =  '';
	window.open("./cus0401_d_sc_serv_off.jsp", "CLIENT", "left=100, top=120, width=530, height=400, resizable=yes, scrollbars=yes, status=yes");
}
	
	function set_dc1(){
		fm = document.form1;
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
	//	fm.dc.value = parseDecimal(dc);
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
	
			
	function chk_add_amt(){  //item serv 에서 호출
		fm = document.form1;		
						
		if(fm.r_chk_amt.value == '0'  )		{	alert("데이타 입력이 완료된 후 하단의 등록버튼을 클릭하세요!!");	}
		
		
		//부품관련 계산			
		var r_amt = toInt(parseDigit(fm.r_amt.value));
		var r_dc1 = r_amt *(toInt(fm.r_dc_per.value)/100);
				
		var r_dc =  toInt(parseDigit(fm.r_dc.value)); 
	             	         
		fm.r_j_amt.value = parseDecimal(r_amt - r_dc1 - r_dc);
		
				//정산완료건 부품데이타 확인 
		if(fm.jung_st.value != "") {	
		   if ( toInt(parseDigit(fm.r_j_amt.value))  !=  <%=siBn.getR_j_amt()%>  ) {
		      alert("부품정산금액 데이타가 차이가 발생했습니다. 확인하세요!!");	
		   }
		}
		
		
		var item_sum = toInt(parseDigit(fm.r_labor.value))+  toInt(parseDigit(fm.r_j_amt.value));
		 
		if ( item_sum > 0 ) {		              
				fm.sup_amt.value = parseDecimal(item_sum);	//공급가 sum							
		}
				
		set_add_amt();
			
	}

	function set_add_amt(){
		fm = document.form1;
			
	//	var item_sum = toInt(parseDigit(fm.r_labor.value))+  toInt(parseDigit(fm.r_j_amt.value));
		
	//	alert(item_sum);
	//	var add_amt = item_sum/10;   //부가세 계산
	//	alert(add_amt);
	//	var dc = toInt(parseDigit(fm.dc.value))
				    
	//          if ( toInt(parseDigit(fm.add_amt.value))  > 0 ) {   //데이타가 있는 경우 - 부가세를 입력한 경우  - 입력한(된) 부가세로 정비금액, 지불금액 계산	            		
	//            		var add = toInt(parseDigit(fm.add_amt.value));
	//			fm.rep_amt.value = parseDecimal(item_sum+add);
	//			fm.tot_amt.value = parseDecimal(item_sum+add-dc);					
	         
	   //       }   else {      //신규인경우
	//			fm.sup_amt.value = parseDecimal(item_sum);	
	//		fm.add_amt.value = parseDecimal(add_amt);
	//		fm.rep_amt.value = parseDecimal(item_sum+add_amt);
	//		fm.tot_amt.value = parseDecimal(item_sum+add_amt-dc);						
	//	}
				
		//item_select 초기화 
		fm.item_st.value = "";
		fm.item.value = "";
		fm.wk_st.value = "";
		fm.count.value = "";
		fm.price.value = "";
		fm.price1.value = "";
		fm.item_cd.value = "";
		fm.amt.value = "";
		fm.labor.value = "";
	//	fm.bpm.value = "";
					
	}
	
	
	function enter3(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_tot_amt();
	}	
		
	function set_tot_amt(){
		fm = document.form1;		
	
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
		
	function set_rep_amt(){
		fm = document.form1;		
		var sup_amt = toInt(parseDigit(fm.sup_amt.value));
		var add_amt = toInt(parseDigit(fm.add_amt.value));
		fm.rep_amt.value = parseDecimal(sup_amt+add_amt);	
		
		var dc = toInt(parseDigit(fm.dc.value))
		rep_amt = toInt(parseDigit(fm.rep_amt.value));
		fm.tot_amt.value = parseDecimal(rep_amt - dc);
	}
	
		
	function enter5(){
		var keyValue = event.keyCode;
		if (keyValue =='13') set_r_j_amt();
	}	
	
	function set_r_j_amt(){  // dc율반영후 끝전 dc
		fm = document.form1;
		r_amt = toInt(parseDigit(fm.r_amt.value));
		
		var r_dc1 = r_amt *(toInt(fm.r_dc_per.value)/100);
		 
		r_dc =  toInt(parseDigit(fm.r_dc.value)); 
	     	         
		fm.r_j_amt.value = parseDecimal(r_amt - r_dc1 - r_dc);
						
	//	fm.r_j_amt.value = parseDecimal(r_amt - r_dc);
		
		var item_sum = toInt(parseDigit(fm.r_labor.value))+  toInt(parseDigit(fm.r_j_amt.value));
		fm.add_amt.value = "0"; //부가세 다시 입력하도록
	//	var add_amt = item_sum/10;
	//	var dc = toInt(parseDigit(fm.dc.value))
	
		fm.sup_amt.value = parseDecimal(item_sum);	
	//	fm.add_amt.value = parseDecimal(add_amt);
	//	fm.rep_amt.value = parseDecimal(item_sum+add_amt);
	//	fm.tot_amt.value = parseDecimal(item_sum+add_amt-dc);		
	
	}
			
	
function UpdShAmt(){
	var fm = document.form1;
	if(fm.serv_st.value=="")		{	alert("정비분류를 선택해 주세요!");		fm.serv_st.focus(); 		return; }
	
	if(!confirm('재리스수리비 공제금액을 등록 하시겠습니까?')){ return; }
	fm.action = "/acar/cus_reg/upd_sh_amt.jsp";
	fm.target = "i_no";
	fm.submit();
}	

//탁송업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 업체가 없습니다."); return;}
		window.open("/acar/cus0601/cus0602_d_frame.jsp?from_page=/fms2/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=250, scrollbars=yes, status=yes, resizable=yes");
	}		
		
//-->
</script>
<script language="JavaScript">
<!--
function regSpdchk(){
	var fm = document.form1;
	if(!confirm("점검사항을 등록하시겠습니까?")){	return; }
	fm.action = "spdchk_ins.jsp";
	fm.target = "i_no";
	fm.submit();
}

var checkflag = "false";
function AllSelect(){
	if(checkflag == "false"){
		<% for(int i=0;i<spdchks.length; i++){ %>
		document.form1.radiobutton<%= i %>[0].click();
		<% } %>
		checkflag = "true";
		return;
	}else{
		<% for(int i=0;i<spdchks.length; i++){ %>
		document.form1.radiobutton<%= i %>[0].checked = false;
		<% } %>	
		checkflag = "false";
		return;
	}
	
}
function CardDocReg(){
	var fm = document.form1;
	
	if (toInt(parseDigit(fm.card_tot_amt.value)) < 1 )		{	alert("정비등록을 먼저 입력해주세요!");	return; }
	
	fm.action = "/card/doc_reg/serv_doc_reg_i.jsp";
	window.open("about:blank", "CardDocView", "left=20, top=20, width=900, height=700, resizable=yes, scrollbars=yes, status=yes");
	fm.target = "CardDocView";
	fm.submit();
}
function view_spdchk(){
	var fm = document.form1;
	<%if(x+y+z >0){%>
	if(fm.view_display.value==''){
		spdchk.style.display 	= '';
		general.style.display 	= 'none';
		fm.view_display.value	= '1';
	}else{
		spdchk.style.display 	= 'none';	
		general.style.display 	= '';
		fm.view_display.value	= '';
	}
	<%}%>
}

	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='/fms2/service/serv_doc_sanction.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}									
	}
	
	function serv_print(){
		var fm = document.form1;
		fm.action='serv_reg_print.jsp';		
		fm.target='_blank';
		fm.submit();
	}	
		
	//스캔삭제
	function scan_del(serv_id){
		var fm = document.form1;
		if(!confirm('삭제하시겠습니까?')){		return;	}
		if(!confirm('정말 삭제하시겠습니까?')){		return;	}		
		fm.target = "i_no"
		fm.action = "/acar/accid_mng/del_scan_a.jsp";
		fm.submit();
	}			
	
	function update_dist(){
		var fm = document.form1;
		if(confirm('주행거리를 수정하시겠습니까?')){	
			fm.action='/fms2/service/serv_dist_u_a.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}											
	}	
	
	
	function reg_save(){
		var fm = document.form1;	
		fm.cmd.value= 'i';		
	//	fm.target='i_no';
		fm.target='_self';
		fm.submit();		
	}
		
	
	function item_del(){
	var fm = document.item_serv_in.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
			}
		}
	}
	if(cnt == 0){ alert("삭제할 작업이나 부품을 선택하세요 !"); return; }
	
	if(!confirm('선택한 부분을 삭제 하시겠습니까?')){	return;	}
	fm.action = "item_serv_del1.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>";
	fm.target = "i_no";
	fm.submit();
}
function item_del_all(){
	fm = document.item_serv_in.form1;
	if(!confirm('전체 삭제 하시겠습니까?')){	return;	}
	fm.action = "item_serv_del1.jsp?del=all";
	fm.target = "i_no";
	fm.submit();
}

function insert_item(){
	var fm = document.form1;
	if(fm.item.value==""){	alert("정비내역을 입력해 주세요!");	fm.item.focus(); return; }
          
         fm.add_amt.value = "0"; //부가세 다시 입력하도록    
	fm.action = "item_serv_iu1.jsp";
	
	fm.target = "i_no";
	fm.submit();
	
	
}

function itemAmt(danga){
	var fm = document.form1;
	var cnt = parseDigit(fm.count.value);
	fm.amt.value = parseDecimal(cnt * parseDigit(danga));
	fm.amt.focus(); //fm.labor.focus(); 원래
	return parseDecimal(danga);
}


function itemAmt1(danga){
	var fm = document.form1;
	if ( danga > 0) {
		var cnt = parseDigit(fm.count.value);
		fm.amt.value = parseDecimal(cnt * parseDigit(danga) / 1.1);
		fm.amt.focus(); //fm.labor.focus(); 원래
	}	
		return parseDecimal(danga);
		
}

function changeWk_st(arg){
	var fm = document.form1;
	if(arg=="1"){
		fm.wk_st.value = "교환";
	}else if(arg=="2"){
		fm.wk_st.value = "도장";
	}else if(arg=="3"){
		fm.wk_st.value = "탈착";
	}else if(arg=="4"){
		fm.wk_st.value = "오버홀";		
	}else if(arg=="5"){
		fm.wk_st.value = "판금";		
	}

}

function changeItem_st(arg){
	var fm = document.form1;
	if(arg=="1"){
		fm.item_st.value = "주작업";
	}else if(arg=="2"){
		fm.item_st.value = "부수작업";		
	}else if(arg=="3"){
		fm.item_st.value = "부품";
	}
}

//년초 날짜 오입력 관련 수정건 - 고객팀장, 전산팀 , 정산안한건만 가능 - 20210114
function update_dt(gubun){
	var fm = document.form1;
	
	fm.gubun.value = gubun;
	
	if(confirm('날짜를 수정하시겠습니까?')){	
		fm.action='/acar/cus_reg/upd_dt_a.jsp';		
		fm.target='i_no';
//		fm.target='_blank';
		fm.submit();
	}											
}	

//-->
</script>
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="view_display" value="">
<input type='hidden' name="auth_rw" value="">
<input type='hidden' name='c_id' 		value='<%= car_mng_id %>'>
<input type='hidden' name='car_mng_id' 	value='<%= car_mng_id %>'>
<input type='hidden' name='serv_id' 	value='<%= serv_id %>'>
<input type='hidden' name='off_id' 		value='<%= siBn.getOff_id() %>'>
<input type='hidden' name='cmd' 		value='<%= cmd %>'>
<input type='hidden' name='accid_id' 	value='<%= siBn.getAccid_id() %>'>
<input type='hidden' name='accid_st' 	value='<%= accid_st%>'>
<input type='hidden' name='rent_mng_id' value='<%= rent_mng_id %>'>
<input type='hidden' name='rent_l_cd' 	value='<%= rent_l_cd %>'>
<input type='hidden' name='jung_st' 	value='<%= siBn.getJung_st() %>'>
<input type='hidden' name='car_no' 		value='<%= ci_bean.getCar_no() %>'>
<input type='hidden' name='card_tot_amt' value= '<%= siBn.getTot_amt() %>'>
<input type='hidden' name='from_page'	value='<%=from_page%>'>   
<input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
<input type='hidden' name="doc_bit" 	value="">    
<input type='hidden' name='chk_amt' value= '<%= siBn.getSup_amt() %>'>
<input type='hidden' name="accid_dt" 	value="<%=accid_dt%>"> 
<input type='hidden' name="gubun" value="">    
<table width="850" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > <span class=style5>자동차정비등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                <td class='title' width=10%>차량번호</td>
                <td class='left' width=15% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_no() %> 
                <%if(  nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) {%>
                <a href="javascript:search_car()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a>
               	<%}%>                               
                </td>
                <td class='title' width=10%>차명</td>
                <td class='left' width=40% align="left">&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %> <%= ci_bean.getCar_nm() %></td>
                <td class='title' width=10%>최초등록일</td>
                <td class='left' width=15% align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
                </tr>
                <tr>
                  <td class='title'>상호</td>
                  <td colspan='5'>&nbsp;&nbsp;<%= client.getFirm_nm() %></td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr> 
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
					<td class=title width=10%>검사유효기간</td>
					<td width=40%>&nbsp; 
					  <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(carinfoBn.getMaint_st_dt())%>" size="10" class=whitetext>
					  ~ 
					  <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(carinfoBn.getMaint_end_dt())%>" size="10" class=whitetext>
					  &nbsp; 
					</td>
					<td class=title width=10%>점검유효기간</td>
					<td width=40%>&nbsp; 
					  <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
					  ~&nbsp; 
					  <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
					</td>
				</tr>
            </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <% if ( siBn.getServ_st().equals("4") && b_dist > 0 ) { %>
    <tr>
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>계기판 교환 내역</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td class='title' width=10%>변경전 주행거리</td>
                    <td align="left">&nbsp;<%=AddUtil.parseDecimal(b_dist)%>km</td>
                  
                </tr>
            </table>
	    </td>
    </tr>	
    <tr>
        <td></td>
    </tr>
    <% } %>  
    
    
    <tr> 
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차점검</span>
					<font color="#999999">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(최초등록일:<%=AddUtil.ChangeDate2(siBn.getReg_dt())%>, 최초등록자:<%=c_db.getNameById(siBn.getReg_id(), "USER")%>)</font>
					</td>
                    <td align="right"><font color="#666666">&nbsp;</font></td>
                </tr>	
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>	  
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class='title' width=10%>점검자</td>
                                <td class='left' width=15%>&nbsp;
                                <select name="checker">
            					  <option value='' >=선택=</option>	
            		                <%if(user_size > 0){
            							for(int i = 0 ; i < user_size ; i++){
            								Hashtable user = (Hashtable)users.elementAt(i); 
            							%>
            		          				  <option value='<%=user.get("USER_ID")%>' <% if(siBn.getChecker().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
            		                <%	}
            						}		%>
            				    </select></td>
                                <td class='title' width=10%>시행자</td>
                                <td width=15%>&nbsp;
            				    <select name='checker_st'>
                                  <option value="">=선택=</option>
                                  <option value="1" <% if(siBn.getChecker_st().equals("1")) out.print("selected"); %>>관리자</option>
            					  <option value="2" <% if(siBn.getChecker_st().equals("2")) out.print("selected"); %>>업무협조</option>
            					  <option value="4" <% if(siBn.getChecker_st().equals("4")) out.print("selected"); %>>순회점검팀</option>
            					  <option value="3" <% if(siBn.getChecker_st().equals("3")) out.print("selected"); %>>고객</option>
                                </select></td>
                                <td class='title' width=10%>순회점검일</td>
                                <td class='left' width=15%>&nbsp; <input name="spdchk_dt" type="text" class="text" value="<%= AddUtil.ChangeDate2(siBn.getSpdchk_dt()) %>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
                               <%	if(siBn.getJung_st().equals("") &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) ){%>	
                                &nbsp;<a href="javascript:update_dt(1)"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
                               <% } %>
                                </td>
                                <td class='title' colspan="2" width=25%>순회점검상태 <a href="javascript:view_spdchk()"><img src=../images/center/button_in_list1.gif border=0 align=absmiddle></a></td>
                            </tr>
                            <tr> 
                                <td class='title'>실주행거리</td>
                                <td colspan="3" class='left'>&nbsp; <input name="tot_dist"  class="num" size="10" maxlength='7'  value="<%if(cmd.equals("4")&&siBn.getTot_dist().equals("")){
				  						
										 }else{
										 	out.print(AddUtil.parseDecimal(siBn.getTot_dist()));} %>" onBlur='javascript:this.value=parseDecimal(this.value)'>
                                km 
								<%if(!from_page.equals("/acar/cus_pre/cus_pre_sc_gs.jsp")){%>
									<%//if(AddUtil.parseInt(siBn.getTot_dist()) > 0 ){%>
								&nbsp;<a href="javascript:update_dist()"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>								
									<%//}%>
								<%}%>
								</td>
                                <td class='title'>점검예정일</td>
                                <td class='left'>&nbsp; <input name="next_serv_dt" type="text"  class="text" value="<%= AddUtil.ChangeDate2(siBn.getNext_serv_dt()) %>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                                <td class='title'>양호</td>
                                <td align="center" class='left'><input type="text" name="x" class="whitenum" value="<%= x %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title' rowspan="3">조치</td>
                                <td class='left' colspan="5" rowspan="3" width=65%>&nbsp; <textarea name="rep_cont" cols="80" rows="3" style='IME-MODE: active'><%= siBn.getRep_cont() %></textarea> 
                                </td>
                                <td class='title'>보통</td>
                                <td class='left' align="center"><input type="text" name="y" class="whitenum" value="<%= y %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title'>불량</td>
                                <td class='left' align="center"><input type="text" name="z" class="whitenum" value="<%= z %>" size="2"> 건</td>
                            </tr>
                            <tr> 
                                <td class='title'>정비분류</td>
                                <td class='left' align="center">&nbsp;   <!--//20141120 수정      -->
                                  <select name="serv_st" onChange="javascript:cng_display2();">
                			<option value='' >=선택=</option>	
                			<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>
                			<option value="1" selected>순회점검</option>
                			<%}else{%>
                			        <%if(accid_id.equals("")){%>
		                    <option value="1" <% if(siBn.getServ_st().equals("1")) out.print("selected"); %>>순회점검</option>
		                    <option value="2" <% if(siBn.getServ_st().equals("2")||siBn.getServ_st().equals("")) out.print("selected"); %>>일반정비</option>
		                    <option value="3" <% if(siBn.getServ_st().equals("3")) out.print("selected"); %>>보증정비</option>
		    		  <option value="7" <% if(siBn.getServ_st().equals("7")) out.print("selected"); %>>재리스정비</option>
		    		  <option value="11" <% if(siBn.getServ_st().equals("11")) out.print("selected"); %>>신차영업관련</option>
		    		  <option value="4" <% if(siBn.getServ_st().equals("4")) out.print("selected"); %>>계기판교환</option>
		                    <%}else{%>		 
		 			
		            <option value="13" <% if(siBn.getServ_st().equals("13")||accid_st.equals("8")) out.print("selected"); %>>자차</option>
		    		 <option value="7" <% if(siBn.getServ_st().equals("7")||accid_st.equals("8")) out.print("selected"); %>>재리스</option>
		    		 <option value="12" <% if(siBn.getServ_st().equals("12")||accid_st.equals("8")) out.print("selected"); %>>해지</option>		
		   
		                    <%}%>
		                    <%}%>
		                  </select>
		                <%  if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) { %>
		                  <% if ( a_bean.getSettle_st().equals("1")  ) {%>  <!--사고 종결인경우 -->
										<a href="javascript:regGen1()"> [수정]</a>&nbsp;
		                  <%} %>
		                  <%} %> 		                  
		                  </td>
		                
		                 <!--    //20141120 수정     
		                  	<% if (siBn.getServ_st().equals("")){ %>
                			<% 	if(cmd.equals("4")||siBn.getServ_st().equals("4")||siBn.getServ_st().equals("5")||siBn.getServ_st().equals("7")||siBn.getServ_st().equals("12") ||siBn.getServ_st().equals("13")){ %>
                                <option value="4" <% if(accid_st.equals("4")) out.print("selected"); %>>운행자차</option>
                                        <option value="5" <% if(accid_st.equals("5")) out.print("selected"); %>>사고자차</option> 
                                      	<option value="13" <% if(accid_st.equals("13")) out.print("selected"); %>>자차</option>			
					<option value="7" <% if(accid_st.equals("7")) out.print("selected"); %>>재리스</option>				
					<option value="12" <% if(accid_st.equals("12")) out.print("selected"); %>>해지</option>
					<% 	}else{%>
                                        <option value="1">순회점검</option>
                                        <option value="2">일반정비</option>
                                        <option value="3">보증정비</option>
					<option value="7">재리스정비</option>
					<option value="11">신차영업관련</option>					
					<%	}%>
                			<% }else{ %>
                			<% 	if(cmd.equals("4")||siBn.getServ_st().equals("4")||siBn.getServ_st().equals("5") ||siBn.getServ_st().equals("7") ||siBn.getServ_st().equals("12")  ||siBn.getServ_st().equals("13") ){ %>
                                      <option value="4" <% if(siBn.getServ_st().equals("4")) out.print("selected"); %>>운행자차</option>
                                        <option value="5" <% if(siBn.getServ_st().equals("5")) out.print("selected"); %>>사고자차</option>  
                                               <option value="13" <% if(siBn.getServ_st().equals("13")) out.print("selected"); %>>자차</option>		
					<option value="7" <% if(siBn.getServ_st().equals("7")) out.print("selected"); %>>재리스</option>					
					<option value="12" <% if(siBn.getServ_st().equals("12")) out.print("selected"); %>>해지</option>
					<% 	}else{%>
                                        <option value="1" <% if(siBn.getServ_st().equals("1")) out.print("selected"); %>>순회점검</option>
                                        <option value="2" <% if(siBn.getServ_st().equals("2")) out.print("selected"); %>>일반정비</option>
                                        <option value="3" <% if(siBn.getServ_st().equals("3")) out.print("selected"); %>>보증정비</option>
					<option value="7" <% if(siBn.getServ_st().equals("7")) out.print("selected"); %>>재리스정비</option>
					<option value="11" <% if(siBn.getServ_st().equals("11")) out.print("selected"); %>>신차영업관련</option>
					<%	}%>
                			<% } %>                  			
                                </select>                               
                                 </td>
                               -->  
                	
                            </tr>
                        </table>
                    </td>
               </tr>
                         
  			   <tr id="spdchk" style="display:<%
		   if(( siBn.getServ_st().equals("1")&& cmd.equals("b")) ||((!cmd.equals("4"))&&siBn.getServ_st().equals("")&&siBn.getOff_id().equals(""))&&!dept_id.equals("8888")){ %>''<% }else{ %>none<% } %>;"> 
                    <td colspan="2">
                        <table width="850" border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td class=h></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;&nbsp;<img src=../images/center/arrow_car_list.gif align=absmiddle></td>
                            </tr>
                            <tr> 
                                <td> 
                                    <table width="850" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#000000" border="1">
                                        <tr> 
                                            <td width="30" align="center" bgcolor="#CCE2FB">No.</td>
                                            <td width="200" align="center" bgcolor="#CCE2FB">점검항목</td>
                                            <td width="390" height="40" align="center" bgcolor="#FFFFFF">점검내용</td>
                                            <td width="60" align="center" bgcolor="#FFFFFF"> <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:AllSelect()">
                                              양호</td>
                                            <td width="60" align="center" bgcolor="#FFFFFF"> 보통</td>
                                            <td width="60" align="center" bgcolor="#FFFFFF"> 불량</td>
                                        </tr>
                                      <% for(int i=0; i<spdchks.length; i++){ 
                										spdchk = spdchks[i];%>
                                        <tr> 
                                            <input type="hidden" name="chk_id<%= i %>" value="<%= spdchk.getChk_id() %>">
                                            <td align="center" bgcolor="#CCE2FB"><%= i+1 %></td>
                                            <td align="left" bgcolor="#CCE2FB">&nbsp;&nbsp;<%= spdchk.getChk_nm() %></td>
                                            <td height="40" align="left" bgcolor="#FFFFFF">&nbsp;&nbsp;<%= spdchk.getChk_cont() %></td>
                                            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="1" 
                    												<%if(!siBn.getSpd_chk().equals("") && spdchks.length > 0){
                    													for(int j=0; j<spdchks.length; j++){
                    														if(!seq[j].equals("")){
                    															if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("1")){%> checked <%}
                    														}	
                    													  }
                    												 }%>
                    												></td>
                                            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="2" 
                    												<%if(!siBn.getSpd_chk().equals("") && spdchks.length > 0){
                    													for(int j=0; j<spdchks.length; j++){
                    														if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("2")){%> checked <%}
                    													}
                    												}%>
                    												></td>
                                            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="3" 
                    												<%if(!siBn.getSpd_chk().equals("") && spdchks.length > 0){
                    													for(int j=0; j<spdchks.length; j++){
                    														if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("3")){%> checked <%}
                    													  }
                    												 }%>
                    												></td>
                                        </tr>
                                      <% } %>
                                    </table>
                                </td>
                            </tr>
                            <tr> 
                                <td align="right"><a href="javascript:regRound()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;  
                     	        <a href="javascript:window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                <tr id="general" style="display:<% if ((siBn.getServ_st().equals("1")  || siBn.getServ_st().equals("4") ) ||((!cmd.equals("4"))&&siBn.getServ_st().equals("")&&siBn.getOff_id().equals(""))&&!dept_id.equals("8888")){ %>none<% }else{ %>''<% } %>;"> 
                    <td colspan="2">                  
                        <table width="850" border="0" cellspacing="0" cellpadding="0">
                            <tr>                            
                                 <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차정비</span></td>
                             </tr>
                             <tr>
                                 <td class=line2 colspan=2></td>
                             </tr>	  
                             <tr> 
                                  <td class=line colspan="2"> 
                                         <table border="0" cellspacing="1" cellpadding='0' width=100%>
                                             <tr> 
                                                 <td class='title' width=10%>구분</td>
                                                 <td class='left' width=15%>&nbsp; <select name="serv_jc" >
             									       <option value='' >=선택=</option>	
                                                     <option value="1" <% if(siBn.getServ_jc().equals("1")) out.print("selected"); %>>정기방문</option>
                                                     <option value="2" <% if(siBn.getServ_jc().equals("2")) out.print("selected"); %>>고객요청</option>
											   <option value="9" <% if(siBn.getServ_jc().equals("9")) out.print("selected"); %>>고객정비</option>
                                                   </select> </td>
                                                 <td class='title' width=10%>정비일자</td>
                                                 <td class='left' width=25%>&nbsp; <input name="serv_dt" type="text" class="text" value="<%= AddUtil.ChangeDate2(siBn.getServ_dt()) %>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)' <%if(siBn.getOff_nm().equals("타이어휠타운")){%>readOnly<%}%>>
                                                   <%	if(siBn.getJung_st().equals("") &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) ){%>
                                                 &nbsp;<a href="javascript:update_dt(2)"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
                                                <% } %>
                                                 </td>
                                                 <td class='title' width=15%>정비업체 <a href="javascript:MM_openBrWindow2('serv_off.jsp','popwin_serv_off','scrollbars=no,status=no,resizable=no,left=100,top=120,width=750,height=500')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
                                                 <td class='left' width=25%>&nbsp;<input name="off_nm"  class="whitetext" size="22" value="<%= siBn.getOff_nm() %>">&nbsp;<a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td>
                                             </tr>
                                             <tr> 
                                                 <td class='title'>입고담당자</td>
                                                 <td class='left'>&nbsp; <select name='ipgoza'>
             											<option value='' >=선택=</option>	
                                                                                     
             							                <%if(user_size > 0){
             												for(int i = 0 ; i < user_size ; i++){
             													Hashtable user = (Hashtable)users.elementAt(i); 
             											%>
             							          				  <option value='<%=user.get("USER_ID")%>' <% if(siBn.getIpgoza().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
             							                <%	}
             											}		%>
             										</select></td>
             					
                                                 <td class='title'>입고일자</td>
                                                 <td colspan="3" class='left'>&nbsp; <input name="ipgodt" type="text" class="text" value="<%if(!siBn.getIpgodt().equals("")) out.print(AddUtil.ChangeDate2(siBn.getIpgodt().substring(0,8))); %>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'> 
                                                   <select name="ipgodt_h">
                                                     <%for(int i=0; i<25; i++){%>
                                                     <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getIpgodt().equals("")) && siBn.getIpgodt().substring(8,10).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>시</option>
                                                     <%}%>
                                                   </select> <select name="ipgodt_m">
                                                     <%for(int i=0; i<60; i+=5){%>
                                                     <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getIpgodt().equals("")) && siBn.getIpgodt().substring(10,12).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>분</option>
                                                     <%}%>
                                                   </select>
                                                    <%	if(siBn.getJung_st().equals("") &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) ){%>
                                                   &nbsp;<a href="javascript:update_dt(3)"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>                                                                      
                                                  <% } %>
                                                     </td>
                                             </tr>
                                             <tr>
                                                 <td height="20" class='title'>출고담당자</td>
                                                 <td class='left'>&nbsp; <select name='chulgoza'>
             									<option value='' >=선택=</option>	
                                                   <%if(user_size > 0){
             												for(int i = 0 ; i < user_size ; i++){
             													Hashtable user = (Hashtable)users.elementAt(i); 
             										%>
                                                   <option value='<%=user.get("USER_ID")%>' <% if(siBn.getChulgoza().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                                   <%	}
             											}		%>
                                                 </select></td>
                                                 <td class='title'>출고일자</td>
                                                 <td colspan="3" class='left'>&nbsp;
                                                   <input name="chulgodt" type="text" class="text" value="<%if(!siBn.getChulgodt().equals("")) out.print(AddUtil.ChangeDate2(siBn.getChulgodt().substring(0,8))); %>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'>
                                                   <select name="chulgodt_h">
                                                     <%for(int i=0; i<25; i++){%>
                                                     <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getChulgodt().equals("")) && siBn.getChulgodt().substring(8,10).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>시</option>
                                                     <%}%>
                                                   </select>
                                                   <select name="chulgodt_m">
                                                     <%for(int i=0; i<60; i+=5){%>
                                                     <option value="<%=AddUtil.addZero2(i)%>" <% if((!siBn.getChulgodt().equals("")) && siBn.getChulgodt().substring(10,12).equals(AddUtil.addZero2(i))) out.print("selected"); %>><%=AddUtil.addZero2(i)%>분</option>
                                                     <%}%>
                                                   </select>
                                                   <%	if(siBn.getJung_st().equals("") &&  ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) ) ){%>
                                                   &nbsp;<a href="javascript:update_dt(4)"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
                                                   <% } %>
                                                   </td>
                                             </tr>
                                             <tr> 
                                                 <td height="20" class='title'>고객시행자</td>
                                                 <td class='left' colspan="5">&nbsp;접수일: 
                                                   <input type="text" name="cust_act_dt" size="12" class=text value="<%= AddUtil.ChangeDate2(siBn.getCust_act_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value)'>&nbsp;
                                                   이름: 
                                                   <input type="text" name="cust_nm" size="10" class=text value="<%= siBn.getCust_nm() %>">&nbsp;
                                                   연락처: 
                                                   <input type="text" name="cust_tel" size="15" class=text value="<%= siBn.getCust_tel() %>">&nbsp;
                                                   관계: 
                                                   <input type="text" name="cust_rel" size="30" class=text value="<%= siBn.getCust_rel() %>"> 
                                                 </td>
                                             </tr>
                                      </table>
                                  </td>
                            </tr>
                            <tr>
                            	  <td></td>
                            </tr>                                 
                                                                                                   
		                     <tr> 
						            <td width="75%"><img src=../images/center/icon_arrow.gif border=0 align=absmiddle> <span class=style2>정비항목</span>
						                    &nbsp;&nbsp;&nbsp;&nbsp;
						                    		<% 	if( siBn.getJung_st().equals("") ){%>
											<% 	//if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
						                    <a href="javascript:item_del()"><img src=../images/center/button_delete_s.gif border=0 align=absmiddle></a> 
						                    <a href="javascript:item_del_all()"><img src=../images/center/button_delete_all.gif border=0 align=absmiddle></a>
											<%}%>
						              </td>
						              <td width="25%">&nbsp;</td>
						          </tr>
						          <tr> 
						              <td colspan="2">
						                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
						                            <tr>
						                                <td class=line2></td>
						                            </tr>
						                            <tr> 
						                                <td class="line">
						                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
						                                        <tr> 
						                                            <td class=title width=5% >선택</td>
						                                            <td class=title width=5% >연번</td>
						                                            <td class=title width=7% >구분</td>
						                                            <td class=title width=20% >내역</td>
						                                            <td class=title width=7%  >작업</td>
						                                            <td class=title width=5%  >수량</td>
						                                            <td class=title width=12% >단가</td>
						                                            <td class=title width=10% >부품코드</td>
						                                            <td class=title width=10% >부품</td>
						                                            <td class=title width=10% >공임</td>
						                                            <td class=title width=9%  >공급처</td>
						                                        </tr>				                                     				                                        
						                                    </table>
						                                </td>
						                                <td width=17>&nbsp;</td>
						                            </tr>
						                        </table>
						                    </td>
						              </tr>
						              <tr> 
						                    <td colspan="2"><iframe src="item_serv_in1.jsp?car_mng_id=<%= car_mng_id %>&serv_id=<%= serv_id %>" name="item_serv_in" width="100%" height="112" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
						              </tr>
						              <tr> 
							     		    <td>&nbsp;</td>					      
							  		    </tr>
						              <tr> 
						                    <td colspan="2">
						                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
						                           <tr> 
						                  				  <td><div align="left">
						                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						                             <font color="red">단가(공급가 / 부가세포함) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※부가세포함에 입력시 공급가 계산</font>      </div></td>
						                   				  <td>&nbsp;</td> 
						             			    </tr>
						                 				                
						               				 <tr> 
					                                <td class="line">
					                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
					                                        <tr> 
					                                          	<input type="hidden" name="item_id" value="">
					                                              <td width=5%>&nbsp;<input type="text" name="seq_no" value=""  readonly size=2 class=whitetext></td>
					                                            <td width=5% align="center">&nbsp;</td>
					                                            <td width=7% align="center"><input type="text" name="item_st" size="6" class=text onBlur='javascript:changeItem_st(this.value)'></td>
					                                            <td width=20%>&nbsp; <input type="text" name="item" size="20" class=text style='IME-MODE: active'></td>
					                                            <td width=7% align="center"><input type="text" name="wk_st" size="6" class=text onBlur='javascript:changeWk_st(this.value)'></td>
					                                            <td width=5% align="center"><input type=text name="count" value=""  size=3 class=num onBlur='javascript:this.value=parseDecimal(this.value)'></td>
					                                            <td width=6% align="center"><input type=text name="price" value=""   size=7 class=num onBlur='javascript:this.value=itemAmt(this.value)'></td>
					                                            <td width=6% align="center"><input type=text name="price1" value="" size=7  class=num onBlur='javascript:this.value=itemAmt1(this.value)'></td>
					                                            <td width=10%>&nbsp; <input type="text" name="item_cd" size="10" class=text></td>						
					                                            <td width=10% align="center"><input type=text name="amt" value="" size=8 class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					                                             </td>
					                                            <td width=10% align="center"><input type=text name="labor" value="" size=8 class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
					                                              </td>
					                                            <td width=9% align="center"><select name="bpm">
					                                                <option value="1">자가</option>
					                                                <option value="2" selected>업체</option>
					                                              </select></td>
					                                        </tr>
					                                    </table>
					                                </td>
					                                <td width=17>&nbsp;</td>
						                            </tr>
						                        </table>
						                     </td>
						                </tr>
						                <tr> 
						                    <td><div align="left">
						                    	<% 	if( siBn.getJung_st().equals("") ){%>
						                        <a href="javascript:insert_item()"><img src=../images/center/button_conf.gif border=0 align=absmiddle></a>	
						                        <% } %>			                  
						                      <font color="red">※구분(1:주작업,2:부수작업,3:부품) &nbsp;&nbsp;※작업(1:교환,2:도장,3:탈착,4:오버홀,5:판금)</font>      </div></td>
						                     <td>&nbsp;</td> 
						               </tr> 
					                                          
		                            <tr> 
		                                 <td colspan="2" class=line2></td>
		                            </tr>
		                                                                                                        
							    	     <tr> 
								   		     <td colspan="2" class="line">
										    	<table border="0" cellspacing="1" cellpadding='0' width=100%>
					                                                      	        <tr> 
					                                                                    <td class='title' >공임</td>
					                                                                    <td>&nbsp;
														 <input type="text" name="r_labor" size="8" class=whitenum readonly="true" >
					                                                                      원&nbsp;</td>
					                                                                    <td class='title' >부품</td>
					                                                                    <td>&nbsp; 
														  <input type="text" name="r_amt" size="8" class=whitenum readonly="true"  >
					                                                                      원&nbsp;</td>
					                                                                    <td class='title' >부품DC율</td>
					                                                                    <td>&nbsp; 	
					                                                                 			  <input type="text" name="r_dc_per" size="3" class=num  value="<%= AddUtil.parseDecimal(siBn.getR_dc_per()) %>" onBlur="javascript:set_r_j_amt()" onKeyDown="javascript:enter5()">	
												      %&nbsp;</td>
					                                                                </tr>			
					                                                      	        <tr> 
					                                                                    <td class='title' >부품DC</td>
					                                                                    <td>&nbsp; 
															<input type="text" name="r_dc" size="8" class=num  value="<%= AddUtil.parseDecimal(siBn.getR_dc()) %>" onBlur="javascript:set_r_j_amt()" onKeyDown="javascript:enter5()">
					                                                                      원&nbsp;</td>
					                                                                    <td class='title'>부품(정산)</td>
					                            				    <td>&nbsp; <input type="text" name="r_j_amt" size="9" class=num value="<%= AddUtil.parseDecimal(siBn.getR_j_amt()) %>" >
					                                				    원&nbsp;  <%=AddUtil.parseDecimal(siBn.getR_j_amt())%>  </td>                 				
					                                				     <td class='title'>정산회차</td>
					                            				    <td>&nbsp; <%= siBn.getSet_dt() %> -  <%= siBn.getJung_st() %>
					                                				   </td>      
					                                                                </tr>			
									          </table>
									     </td>
								     </tr>	
								     <tr> 
								        <td colspan="2">&nbsp;</td>
								     </tr>	
								     <tr> 
								       <td colspan="2" class="line">
									       <table border="0" cellspacing="1" cellpadding='0' width=100%>																
								    
								          <tr>
								            <td width="100" class='title'>공급가</td>
								            <td width="100" class='left'>&nbsp;
								                <input type="text" name="sup_amt" size="8" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getSup_amt()) %>">
								                원</td>
								            <td width="100" class='title'>부가세</td>
								            <td width="100" class='left'>&nbsp;
								                <input type="text" name="add_amt" size="8" class=num value="<%= AddUtil.parseDecimal(siBn.getAdd_amt()) %>" onBlur="javascript:set_rep_amt()" onKeyDown="javascript:enter3()">
								                원</td>
								            <td width="100" class='title'>정비금액</td>
								            <td class='left'>&nbsp;
								                <input type="text" name="rep_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getRep_amt()) %>">
								                원
								               </td> 
								                <td  colspan=2>&nbsp;&nbsp;&nbsp;<input type="text" name="item_sum" size="9" class=whitenum readonly="true" >&nbsp;&nbsp;&nbsp;<input type="text" name="r_chk_amt" size="9" class=whitenum readonly="true" value='<%= AddUtil.parseDecimal(siBn.getRep_amt()) %>' >
								                </td> 
								                  
								          </tr>
								          <tr> 
								            <td width="100" class='title'>DC</td>
								            <td width="100" class='left'>&nbsp; 
											  <input type="text" name="dc" size="8" class=num value="<%= AddUtil.parseDecimal(siBn.getDc()) %>" onBlur="javascript:set_dc1();" >
								              원</td>
								            <td width="100" class='title'>지급금액</td>
								            <td class='left'>&nbsp; 
											  <input type="text" name="tot_amt" size="9" class=whitenum value="<%= AddUtil.parseDecimal(siBn.getTot_amt()) %>">
								              원              </td>
								              
								                <td class='title'>결제일</td>
			                                                               <td colspan=3  >&nbsp;
			                                                               <input name="set_dt" type="text" class="<%if(dept_id.equals("8888")){%>white<%}%>text" value="<%= AddUtil.ChangeDate2(siBn.getSet_dt()) %>" readonly  size="12" onBlur='javascript:this.value=ChangeDate(this.value)' <%if(dept_id.equals("8888") ||   siBn.getOff_id() .equals("000620") ||   siBn.getOff_id() .equals("009290") ||   siBn.getOff_id() .equals("006858") ){%>readonly="true"<%}%>>
			                                                                      (신용카드 입력시 연동 처리)</td>
								          </tr>
								        				                                                                      
								        </table>
									  </td>
								   </tr>	
    
			    				   <tr> 
								        <td colspan="2">&nbsp;</td>
								   </tr>
			                   <tr> 
			                         <td colspan="2" class="line">
			                                <table border="0" cellspacing="1" cellpadding='0' width=100%>                              
			                                                                                      
			                                    <tr> 
			                                        <td class='title'>call대상자</td>
			                                        <td align=left colspan=3 >&nbsp; <input type="text" name="call_t_nm" size="30" readonly class=whitetext  value="<%=siBn.getCall_t_nm()%>" >
			                                          </td>
			                                        <td class='title'>연락처</td>
			                                        <td align=left colspan=6>&nbsp; <input type="text" name="call_t_tel" size="30" readonly class=whitetext value="<%=siBn.getCall_t_tel()%>" >
			                                          </td>
			                                     
			                                    </tr>
			                                    
			                                </table>
			                            </td>
			                     </tr>	
		                        <tr></tr>
		                        <tr> 
							            <td colspan="2"><font color=red>&nbsp;※ 품목입력(수정)후 하단의 등록버튼을 반드시 클릭하세요.</font></td>
						            </tr>				    										
		                         <tr> 
				                         	<td>&nbsp;<font color=red>*</font>재리스수리비 공제금액&nbsp;<input type="text" name="sh_amt" size="8" class=num <%if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("지점장",user_id) ){%><%}else{%>readonly="true"<%}%> value="<%= AddUtil.parseDecimal(siBn.getSh_amt()) %>">                                                    
				                         	<!--비용담당자 변경 가능토록 -->
				                         	&nbsp;비용담당자&nbsp;<select name='bus_id2'>
											       <option value="">미지정</option>
											       <%	if(user_size > 0){
											for (int i = 0 ; i < user_size ; i++){
												Hashtable user = (Hashtable)users.elementAt(i);	%>
											       <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
											       <%		}
											}		%>
											     </select>
												<%if (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("지점장",user_id) ){%>      
												&nbsp;<a href="javascript:UpdShAmt();"><img src=../images/center/button_modify.gif border=0 align=absmiddle><%}%></a>
										  	</td>
										    <td>
					                           <%if(!from_page.equals("/acar/cus_pre/cus_pre_sc_gs.jsp")){%>     
					                             	<%if(!dept_id.equals("8888") && siBn.getJung_st().equals("") ){%>															
					                      	<!--	<a href="javascript:CardDocReg();"><img src=../images/center/button_reg_card.gif border=0 align=absmiddle></a>  -->
					                             	<%}%>&nbsp;&nbsp;
												<%if(go_url.equals("N")){%>
												&nbsp;
												<% if ( !a_bean.getSettle_st().equals("1") ) {%>  <!--사고 종결이 아니면 -->
												<a href="javascript:regGen()"><img src=../images/center/button_modify_jb.gif border=0 align=absmiddle></a>&nbsp;
												<a href="javascript:regGeneral()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>		
												 <% } %>					
												<%}%>														
												&nbsp;<a href="javascript:window.close();"><img src=../images/center/button_close.gif border=0 align=absmiddle></a>&nbsp;<a href="javascript:serv_print();"><img src=../images/center/button_print.gif border=0 align=absmiddle></a>
												&nbsp;<a href="javascript:MM_openBrWindow2('call_info.jsp?m_id=<%=siBn.getRent_mng_id()%>&l_cd=<%=siBn.getRent_l_cd()%>&c_id=<%=siBn.getCar_mng_id()%>&accid_id=<%=siBn.getAccid_id()%>&serv_id=<%=siBn.getServ_id()%>','call_info','scrollbars=no,status=no,resizable=no,left=100,top=120,width=750,height=300')">call정보</a>
												<%}%>
												<%if (nm_db.getWorkAuthUser("전산팀",user_id) && siBn.getSet_dt().equals("") &&  siBn.getCust_amt() == 0   ) {%>  <!--정산이 안되있고 면책금 청구가 안된건이라면  석제 가능- 전산팀만 -->
												<a href="javascript:delServ();">[삭제]</a>&nbsp;
												<% } %>																		    							    
									       </td>
                              </tr>		
                        </table>
                    </td>               
                </tr>      
            
            </table>
        </td>
    </tr>
  
    <tr>
        <td class=h></td>
    </tr>
	<%if(!card_buy_dt.equals("")){%>						
    <tr> 
      <td colspan="2">&nbsp;※ 법인카드로 결재되었습니다. (<%=serv_card.get("CARDNO")%> <%=serv_card.get("BUY_DT")%>)</td>
    </tr>			
	<%}%>															
	<%if(serv_reg_st.equals("Y")){%>						
    <tr> 
      <td colspan="2">&nbsp;※ 출금원장에서 약식등록되었습니다.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
    </tr>			
	<%}%>																															
	<%if(serv_reg_st.equals("S")){%>						
    <tr> 
      <td colspan="2">&nbsp;※ 출금원장에 출금등록되었습니다.(<%=serv_pay.get("REG_NM")%> <%=serv_pay.get("REG_DT")%>)</td>
    </tr>			
	<%}%>													
	<%if(serv_reg_st.equals("Y") || serv_reg_st.equals("S")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr bgcolor="#FFFFFF"> 
                <td class='title' width=10%>원장번호</td>
                <td width=40%>&nbsp;&nbsp;<%=serv_pay.get("REQSEQ")%></td>
                <td class='title' width=10%>출금일자</td>
                <td width=40%>&nbsp;&nbsp;<%=serv_pay.get("P_PAY_DT")%></td>
              </tr>
			  <%
				String content_code1 = "PAY";
				String content_seq1  = (String)serv_pay.get("REQSEQ");

				Vector attach_vt2 = c_db.getAcarAttachFileList(content_code1, content_seq1, 0);		
				int attach_vt2_size = attach_vt2.size();
				
			//	out.println(content_code1);		
			//	out.println(content_seq1);		
			//	out.println(attach_vt2_size);		
			  %>
			  <%if(attach_vt2_size > 0){%>
			    <%	for (int k = 0 ; k < attach_vt2_size ; k++){
    					Hashtable ht2 = (Hashtable)attach_vt2.elementAt(k);%>
				<tr bgcolor="#FFFFFF"> 
					<td class='title'>증빙서류<%=k+1%></td>						
    				<td colspan='3'>	&nbsp;<a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a>
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht2.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
   			    <%	}%>		
			<%	}%>	
            </table>
	    </td>
    </tr>	
	<%}%>
	
	<%if(siBn.getTot_amt() > 0 || siBn.getTot_amt() < 0 || siBn.getServ_st().equals("4") || siBn.getServ_st().equals("3")){
	
	
			//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
			String content_code = "SERVICE";
			String content_seq  = siBn.getCar_mng_id()+""+siBn.getServ_id();

			Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();		
	
	%>
		
	<tr>
	    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적서 스캔</span></td>
	</tr>	
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr bgcolor="#FFFFFF"> 
                    <td class='title' width=10%>관리번호</td>
                    <td width=15% align="left">&nbsp;<%= siBn.getEstimate_num() %></td>
                    <td class='title' width=10%>견적서</td>
                    <td>&nbsp;
			<%if(attach_vt_size > 0){%>
			    <%	for (int j = 0 ; j < attach_vt_size ; j++){
    					Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
    					&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
    				<% if ( !a_bean.getSettle_st().equals("1") )  {	 %>		
    					&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    			    <% } %>
    					<%if(j+1 < attach_vt_size){%><br><%}%>
    			    <%	}%>		
        		<%}else{%>			
			    <a class=index1 href="javascript:MM_openBrWindow2('/acar/accid_mng/upload.jsp?br_id=<%=acar_br%>&m_id=<%=siBn.getRent_mng_id()%>&l_cd=<%=siBn.getRent_l_cd()%>&c_id=<%=siBn.getCar_mng_id()%>&accid_id=<%=siBn.getAccid_id()%>&serv_id=<%=siBn.getServ_id()%>&mode=<%//=mode%>&gubun=pdf','popwin','scrollbars=no,status=no,resizable=yes,width=500,height=200,left=250, top=250')", title="견적서를 업로드하시려면 클릭하세요"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a>
			<%}%>
		    </td>
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
	<%		if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("보유차관리자들",user_id) || user_id.equals(siBn.getChecker())){%>	
    <tr> 
        <td class='line'> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=20% rowspan="2">결재</td>
                    <td class=title width=20%>청구</td>
                    <td class=title width=20%>확인</td>
                    <td class=title width=20%>관리자</td>
                    <td class=title width=20%>팀장</td>
                </tr>
                <tr>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(doc.getUser_dt2().equals("")){%><br><a href="javascript:doc_sanction('2');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%><%if(doc.getUser_dt3().equals("")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id)){%><br><a href="javascript:doc_sanction('3')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><%}%><%}%></font></td>
                    <td align="center"><font color="#999999"><%=c_db.getNameById(doc.getUser_id4(),"USER_PO")%><br><%=doc.getUser_dt4()%><%if(doc.getUser_dt4().equals("")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("지점장",user_id)){%><br><a href="javascript:doc_sanction('4');" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a> <%}%><%}%></font></td>
                </tr>
            </table>
	    </td>
    </tr>
	<%		}%>
	<%}%>		
	
	<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>
      <tr> 
          <td align="right"><a href="javascript:regRound()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;  
        <a href="javascript:window.close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
      </tr>
	<%}%>		
	
</table>

</form>
</body>
</html>


<script language='javascript'>
<!--
	<%if(from_page.equals("/acar/secondhand/secondhand_price_20090901.jsp")){%>
			spdchk.style.display = 'none';
			general.style.display = 'none';
	<%}%>		
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
