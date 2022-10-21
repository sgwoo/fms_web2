<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.user_mng.*, acar.car_sche.*,acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//납품관리 페이지
	
	String m_id 				= request.getParameter("m_id")				==null?"":request.getParameter("m_id");
	String l_cd 				= request.getParameter("l_cd")				==null?"":request.getParameter("l_cd");
	String c_st 				= request.getParameter("c_st")				==null?"":request.getParameter("c_st");
	String u_st 				= request.getParameter("u_st")				==null?"":request.getParameter("u_st");
	String brch_id 			= request.getParameter("brch_id")			==null?"":request.getParameter("brch_id");
	String user_id 			= request.getParameter("user_id")			==null?"":request.getParameter("user_id");
	String br_id 				= request.getParameter("br_id")				==null?"":request.getParameter("br_id");
	String mode 				= request.getParameter("mode")				==null?"":request.getParameter("mode");
	String car_no_stat 	= request.getParameter("car_no_stat")	==null?"1":request.getParameter("car_no_stat");
	String car_no_leng 	= request.getParameter("car_no_leng")	==null?"8":request.getParameter("car_no_leng");
	String car_ext 			= request.getParameter("car_ext")			==null?"":request.getParameter("car_ext");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(m_id, l_cd);
	
	String gubun = c_db.getNameByIdCode("0032", "", car.getCar_ext());
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- <script language='JavaScript' src='/include/common.js'></script> -->
<script language='javascript'>
<!--
$(document).ready(function(){
	var car_no_stat = '<%=car_no_stat%>';
	var car_no_leng = '<%=car_no_leng%>';
	var c_st = '<%=c_st%>';
	var u_st = '<%=u_st%>';
	var gubun = '<%=gubun%>';
	
	//차량 용도 및 인수지에 맞는 리스트 보여주기
	if(c_st=="렌트"){
		//VV 테슬라 차량때문에 등록지가 대구인 번호 일시적으로 전체보이게(20191101)
		if(gubun=="대구"){		$("#sch_area4").css("display", "");		}
		
		if(u_st=="본사"||u_st=="광주지점"||u_st=="대전지점"){	// <-- 일시적으로 대전지점을 인천번호 default로.	(20191004)
			if(gubun=="서울"){	$("#sch_area8").css("display", "");		}
			else{						$("#sch_area1").css("display", "");		}	
		}
		else if(u_st=="부산지점"){	$("#sch_area2").css("display", "");	}
	//	else if(u_st=="대전지점"){	$("#sch_area3").css("display", "");	}
		else if(u_st=="대구지점"){	$("#sch_area4").css("display", "");	}
		else if(u_st=="고객"){	$("#sch_area1, #sch_area2, #sch_area3, #sch_area4, #sch_area5, #sch_area6").css("display", "");	}
	}else if(c_st=="리스"){
		$("#sch_area7").css("display", "");
		$("#est_car_no").val("리 스");
	}
	
	if(car_no_stat == '1'){
		$("#selectCarExt").css("display","none");	
	}else if(car_no_stat == '2'){
		$("#selectCarExt").css("display","");
	}
	
	//번호검색 셀렉트 박스 
	$("#selectCarNoStat, #selectCarNoLength").on("change", function(){
		var car_no_stat = $("#selectCarNoStat").val();
		var car_no_leng = $("#selectCarNoLength").val();
		var car_ext = $("#selectCarExt").val();
		if(car_no_stat == '1'){
			$("#selectCarExt").css("display","none");
			car_ext = '';
		}else if(car_no_stat == '2'){
			$("#selectCarExt").css("display","");
		}
		location.href='/fms2/car_pur/reg_estcarno.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_st=<%=c_st%>&u_st=<%=u_st%>&br_id=<%=br_id%>&mode=<%=mode%>&car_no_stat='+car_no_stat+'&car_no_leng='+car_no_leng+'&car_ext='+car_ext;
	});
	
	$("#selectCarExt").on("change", function(){
		var car_ext = $("#selectCarExt").val();
		location.href='/fms2/car_pur/reg_estcarno.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_st=<%=c_st%>&u_st=<%=u_st%>&br_id=<%=br_id%>&mode=<%=mode%>&car_no_stat='+car_no_stat+'&car_no_leng='+car_no_leng+'&car_ext='+car_ext;
	});
});

function update(){		
	var fm = document.form1;
	if(fm.est_car_num.value.length == 0){
		fm.action='reg_estcarno_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}else{
		if(fm.est_car_num.value.length != 17){
			alert("차대번호는 17자리를 입력해주세요.");	
		}else{
			fm.action='reg_estcarno_a.jsp';		
			fm.target='i_no';
			fm.submit();		
		}
	}
}

function search_carno(){
	var fm = document.form1;	
	window.open("/acar/car_scrap/scrap_s_frame_m.jsp?from_page=/fms2/car_pur/rent_board_sc_in.jsp&gubun=<%=gubun%>", "SERV_SCRAP", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");		
}

function selectCarNo(num){
	var car_no = $("#car_no"+num).val();
	$("#est_car_no").val(car_no);
}
//-->
</script>
<style>
.new_a { color: red; }
.new_a:link { color: red; }
.new_a:visited { color: red; }
.new_a:hover { color: red; }
.new_a:active { color: red; }
</style>
</head>

<body>
<div style="margin:auto;text-align:center;">
<form name='form1' action='' method='post' style="display:inline-block;">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="mode" value="<%=mode%>">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>희망차량번호 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='29%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='41%'>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>등록지역</td>
                    <td>&nbsp;<%=gubun%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
                <tr> 
                    <td class='title'>계출번호</td>
                    <td>&nbsp;<%=pur.getRpt_no()%></td>
                    <td class='title'>차량인수지</td><!-- 차량인수지, 최초영업자, (관리)담당자, 출고점, 출고연락처 추가 2018.01.15 -->
                    <td>&nbsp;<%=est.get("UDT_ST")%></td>
                </tr>
                <tr>
                	<td class='title'>최초영업자</td>
                    <td>&nbsp;<%=est.get("BUS_NM")%></td>
                    <td class='title'>담당자</td>
                    <td>&nbsp;<%=est.get("MNG_NM")%></td>
                </tr>
                <tr>
                	<td class='title'>출고점</td>
                    <td>&nbsp;<%=est.get("DLV_BRCH")%></td>
                    <td class='title'>출고 연락처</td>
                    <td>&nbsp;<%=est.get("CAR_OFF_TEL")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>희망차량번호</td>
                    <td>&nbsp;<input type='text' size='15' name='est_car_no' id="est_car_no" class='text' value='<%=pur.getEst_car_no()%>'>
    			    <font color="#CCCCCC">(한글10자)</font>
    			    <!--<span class="b"><a href="javascript:search_carno()" onMouseOver="window.status=''; return true" title="클릭하세요">대폐차번호 조회</a></span>-->
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>차대번호</td>
                    <td>&nbsp;<input type="text" size="30" name="est_car_num" id="est_car_num" class="text" value="<%=pur.getCar_num()%>" placeholder="반드시 17자리를 입력해주세요.">
    			    <!--<span class="b"><a href="javascript:search_carno()" onMouseOver="window.status=''; return true" title="클릭하세요">대폐차번호 조회</a></span>-->
    			    </td>
                </tr>
                <tr> 
                    <td class='title'>임시차량번호</td>
                    <td>&nbsp;<input type='text' size='30' name='tmp_drv_no' class='text' value='<%=pur.getTmp_drv_no()%>'>
    			    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
		<%	String reg_id1 = nm_db.getWorkAuthUser("차량등록자");
			String reg_id2 = nm_db.getWorkAuthUser("부산차량등록자");
			String reg_id3 = "";
			String reg_id4 = "";
			String reg_id5 = nm_db.getWorkAuthUser("대전보험담당");
			String reg_id6 = "";
			String reg_id7 = nm_db.getWorkAuthUser("부산보험담당");
			String reg_id8 = "";
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(reg_id1);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id3 = cs_bean.getWork_id();
			}
			cs_bean = csd.getCarScheTodayBean(reg_id2);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id4 = cs_bean.getWork_id();
			}
			if(car.getCar_ext().equals("1") || car.getCar_ext().equals("2") || car.getCar_ext().equals("6") || car.getCar_ext().equals("7")){
				reg_id2 = "";
				reg_id4 = "";
			}
			cs_bean = csd.getCarScheTodayBean(reg_id5);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id6 = cs_bean.getWork_id();
				cs_bean = csd.getCarScheTodayBean(reg_id6);//대전보험담당자 휴가인데 업무대체자도 휴가인 경우 그 다음 업무대체자로 대체
				if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
					reg_id6 = cs_bean.getWork_id();
				}
			}
			cs_bean = csd.getCarScheTodayBean(reg_id7);
			if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
				reg_id8 = cs_bean.getWork_id();
				cs_bean = csd.getCarScheTodayBean(reg_id8);//부산보험담당자 휴가인데 업무대체자도 휴가인 경우 제3 업무대체자로 대체
				if(!cs_bean.getUser_id().equals("") && !cs_bean.getWork_id().equals("")){
					reg_id8 = cs_bean.getWork_id();
				}
			}
			%>
			
		<%if(nm_db.getWorkAuthUser("전산팀", ck_acar_id) || nm_db.getWorkAuthUser("출고일자등록", ck_acar_id) || nm_db.getWorkAuthUser("출고관리자", ck_acar_id) || nm_db.getWorkAuthUser("영업수당관리자", ck_acar_id) || nm_db.getWorkAuthUser("납품준비상황등록업무", ck_acar_id) || nm_db.getWorkAuthUser("대출관리자", ck_acar_id) || ck_acar_id.equals(reg_id1) || ck_acar_id.equals(reg_id2) || ck_acar_id.equals(reg_id3) || ck_acar_id.equals(reg_id4) || ck_acar_id.equals(reg_id5) || ck_acar_id.equals(reg_id6) || ck_acar_id.equals(reg_id7) || ck_acar_id.equals(reg_id8)){%>		
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    
    
<%if(nm_db.getWorkAuthUser("차량번호관리", ck_acar_id)||nm_db.getWorkAuthUser("전산팀", ck_acar_id)){ %>    
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td>
        	<span style="color: red; font-weight: bold;">※ 아래 번호검색 차량번호 빨간색 표기는 구형번호판 입니다.</span><br>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>번호검색</td>
                    <td width='*' align="left">
                    	<input type="hidden" name="car_nm" value="<%=est.get("CAR_NM")%>">&nbsp;
                    	<select name="car_no_stat" id="selectCarNoStat">
							<option value="1" <%if(car_no_stat.equals("1")){%> selected <%}%>>신규번호</option>
                    		<option value="2" <%if(car_no_stat.equals("2")){%> selected <%}%>>반납번호(대차,대기상태)</option>
                    	</select>
                    	<!-- 자리수 검색 추가 (20190813) -->
                    	<select name="car_no_leng" id="selectCarNoLength">
							<option value="7" <%if(car_no_leng.equals("7")){%> selected <%}%>>7자리</option>
                    		<option value="8" <%if(car_no_leng.equals("8")){%> selected <%}%>>8자리</option>
                    	</select>
	                </td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td class='line' colspan="2">
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
							<colgroup>
								<col width="10%">
								<col width="*">
							</colgroup>
							<tr id="sch_area1" style="display: none;" width=100%>
								<td class="title">인천</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_1 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "인천","2","","");
	if(lists_1.size() > 0){
		for(int i =0; i < lists_1.size() ; i++){
			Hashtable list_1 = (Hashtable)lists_1.elementAt(i);	%>
			<%if(!String.valueOf(list_1.get("KEEP_YN")).equals("Y")){ %>			
									<a href="#" onclick="javascript:selectCarNo(1<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_1.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_1.get("CAR_NO")%></a>
			<%}else{ %>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_1.get("KEEP_ETC")%>' <%if (String.valueOf(list_1.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_1.get("CAR_NO")%></span>&nbsp;
			<%} %>					  	
									<input type="hidden" id="car_no1<%=i+1%>" value="<%=list_1.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%	} %>						</td>
							</tr>
							<tr id="sch_area2" style="display: none;">
								<td class="title">부산</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_2 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "부산","2","","");
	if(lists_2.size() > 0){
		for(int i =0; i < lists_2.size() ; i++){
			Hashtable list_2 = (Hashtable)lists_2.elementAt(i);	%>
			<%if(!String.valueOf(list_2.get("KEEP_YN")).equals("Y")){%>  	
									<a href="#" onclick="javascript:selectCarNo(2<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_2.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_2.get("CAR_NO")%></a>
			<%}else{%>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_2.get("KEEP_ETC")%>' <%if (String.valueOf(list_2.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_2.get("CAR_NO")%></span>&nbsp;
			<%}%>						
									<input type="hidden" id="car_no2<%=i+1%>" value="<%=list_2.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%} %>						</td>
							</tr>
							<tr id="sch_area3" style="display: none;">
								<td class="title">대전</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_3 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "대전","2","","");
	if(lists_3.size() > 0){
		for(int i =0; i < lists_3.size() ; i++){
			Hashtable list_3 = (Hashtable)lists_3.elementAt(i);	%>  	
			<%if(!String.valueOf(list_3.get("KEEP_YN")).equals("Y")){%> 
									<a href="#" onclick="javascript:selectCarNo(3<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_3.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_3.get("CAR_NO")%></a>
			<%}else{%>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_3.get("KEEP_ETC")%>' <%if (String.valueOf(list_3.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_3.get("CAR_NO")%></span>&nbsp;
			<%}%>						
									<input type="hidden" id="car_no3<%=i+1%>" value="<%=list_3.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%	} %>						</td>
							</tr>
							<tr id="sch_area4" style="display: none;">
								<td class="title">대구</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_4 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "대구","2","","");
	if(lists_4.size() > 0){
		for(int i =0; i < lists_4.size() ; i++){
			Hashtable list_4 = (Hashtable)lists_4.elementAt(i);	%>
			<%if(!String.valueOf(list_4.get("KEEP_YN")).equals("Y")){%>   	
									<a href="#" onclick="javascript:selectCarNo(4<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_4.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_4.get("CAR_NO")%></a>
			<%}else{ %>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_4.get("KEEP_ETC")%>' <%if (String.valueOf(list_4.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_4.get("CAR_NO")%></span>&nbsp;
			<%} %>						
									<input type="hidden" id="car_no4<%=i+1%>" value="<%=list_4.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%	} %>						</td>
							</tr>
							<tr id="sch_area5" style="display: none;">
								<td class="title">포천</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_5 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "포천","2","","");
	if(lists_5.size() > 0){
		for(int i =0; i < lists_5.size() ; i++){
			Hashtable list_5 = (Hashtable)lists_5.elementAt(i);	%>  
			<%if(!String.valueOf(list_5.get("KEEP_YN")).equals("Y")){%>
									<a href="#" onclick="javascript:selectCarNo(5<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_5.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_5.get("CAR_NO")%></a>
			<%}else{%>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_5.get("KEEP_ETC")%>' <%if (String.valueOf(list_5.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_5.get("CAR_NO")%></span>&nbsp;
			<%}%>						
									<input type="hidden" id="car_no5<%=i+1%>" value="<%=list_5.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%	} %>						</td>
							</tr>
							<tr id="sch_area6" style="display: none;">
								<td class="title">파주</td>
								<td>
									<div style="height: 10px;"></div>
<%	Vector lists_6 = sc_db.getNewCarNumList(car_no_stat, car_no_leng, "파주","2","","");
	if(lists_6.size() > 0){
		for(int i =0; i < lists_6.size() ; i++){
			Hashtable list_6 = (Hashtable)lists_6.elementAt(i);	%>
			<%if(!String.valueOf(list_6.get("KEEP_YN")).equals("Y")){%>  	
									<a href="#" onclick="javascript:selectCarNo(6<%=i+1%>);" style="padding: 7px; height: 20px;" <%if (String.valueOf(list_6.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_6.get("CAR_NO")%></a>
			<%}else{%>
									&nbsp;<span onMouseOver="window.status=''; return true" title='<%=list_6.get("KEEP_ETC")%>' <%if (String.valueOf(list_6.get("NEW_LICENSE_PLATE_YN")).equals("N")) {%>class="new_a"<%}%>><%=list_6.get("CAR_NO")%></span>&nbsp;
			<%}%>						
									<input type="hidden" id="car_no6<%=i+1%>" value="<%=list_6.get("CAR_NO")%>">                  		
<%			if(i != 0 && i%6 == 5){%>
									<div style="height: 10px;"></div>
<% 			}  
		}
			%>						<div style="height: 10px;"></div><%		
	}else{	%>
									<div>&nbsp;차량번호가 존재하지 않습니다.</div><div style="height: 10px;">
<%	} %>						</td>
							</tr>
							<tr id="sch_area7" style="display: none;" width="100%">
								<td colspan="2" width="100%">&nbsp;용도가 [리 스]인 차량입니다.</td>
							</tr>
							<tr id="sch_area8" style="display: none;" width="100%">
								<td colspan="2" width="100%">&nbsp;차량번호가 존재하지 않습니다.</td>
							</tr>
						</table>        	 
    			    </td>
                </tr>
            </table>
        </td>
    </tr>
<%} %>
</table>
</form>
</div>
<script>
	// 차대번호 영소문자 대문자로 변경		2017. 12. 08
	var est_car_num = $("#est_car_num");
	est_car_num.change(function(){
		var regex = /[^0-9A-Za-z]/gi;
		var oldLetter = est_car_num.val();
		var modifiedString = oldLetter.replace(regex, "");	// 숫자, 영어 이외 제거
		modifiedString = modifiedString.toUpperCase();		// 영소문자 대문자로 변경		
		est_car_num.val(modifiedString);
	});
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
