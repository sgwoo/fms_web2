<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.user_mng.*"%>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String sh_height 	= request.getParameter("sh_height")==null?"0":request.getParameter("sh_height");
		
	Vector vt = shDb.getShResMngList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4);  
	int cont_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ;
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;
	}
	
	function init(){
		setupEvents();
	}	

	function EstiMemo(est_id, user_id, chk, bb_chk, t_chk){
		var fm = document.estiSpeFrm;
		fm.t_chk.value = t_chk;
		fm.bb_chk.value = bb_chk;
		fm.chk.value = chk;
		fm.est_id.value = est_id;
		fm.user_id.value = user_id;
		fm.target = "d_content"
		fm.action = "/acar/estimate_mng/esti_spe_hp_i.jsp";
		fm.submit();
	}

//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="estiSpeFrm" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">  
	<input type="hidden" name="user_id" value="">         
	<input type="hidden" name="est_id" value="">       
	<input type="hidden" name="t_chk" value="">  
	<input type="hidden" name="bb_chk" value="">  
	<input type="hidden" name="chk" value=""> 
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>	
	<input type="hidden" name="from_page" value="/acar/secondhand/sh_res_frame.jsp"> 
</form>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='s_kd' value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='andor' value='<%=andor%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/acar/secondhand/sh_res_frame.jsp'>
  <input type='hidden' name='ext_est_dt' value=''>  
  <table border="0" cellspacing="0" cellpadding="0" width='1730'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='600' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                  <td width='50' class='title'>연번</td>
                  <td width='100' class='title'>차량번호</td>
                  <td width='150' class='title'>차종</td>
                  <td width="80" class='title'>차량상태</td>
                  <td width="80" class='title'>구분</td>
                  <td width="30" class="title">순위</td>
                  <td width="80" class='title'>예약상태</td>
                  <td width="80" class='title'>진행상황</td>
                </tr>
            </table>
    	</td>
	    <td class='line' width='1070'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	    <tr>
        	    	<td width="100" class='title'>차량현위치</td>
        	    	<td width="100" class='title'>영업지점</td>
       	    	    <td width="200" class='title'>고객명</td>
       		        <td width="110" class='title'>연락처</td>
       		        <td width="160" class='title'>예약기간</td>
       		        <td width="250" class='title'>메모</td>
       		        <td width="70" class='title'>담당자</td>
       		        <td width="150" class='title'>등록일시</td>
        	    </tr>
	        </table>
	    </td>
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='600' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <%
            	int rank = 1;
            	String tempCarId ="";
            	
            	for(int i = 0 ; i < cont_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					String td_color = "";
					if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = "class='is'";
					String carNo = (String)ht.get("CAR_NO");
					//차량 순위 출력
					if(tempCarId.equals(carNo)){
						rank ++;
					}else{
					    tempCarId = carNo;
					    rank = 1;
					}
					
			%>
                <tr> 
                  <td <%=td_color%> width='50' align='center'><%=i+1%></td>
                  <td <%=td_color%> width='100' align='center'>
                  	<%
                  	  String estiGubun = "";
                  	  if(ht.get("EST_ID") != null && ht.get("EST_ID") != ""){
                  	  	estiGubun = "(HP)";
                  	      //홈페이지에서 온 월렌트면 esti_spe_hp_i.jsp 로 이동한다%>
                  	  	
                  		<a href="javascript:EstiMemo('<%=ht.get("EST_ID")%>','<%=ck_acar_id%>','1','','');" title="이력">
                  	<%}else{ %>
                  		<a href="javascript:parent.view_sh_res('<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("RES_ST")%>','<%=ht.get("USE_ST")%>')" title="이력">
                  	<%} %>
                  		<%=ht.get("CAR_NO")%>
                  	</a>
                  </td>
                  <td <%=td_color%> width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CAR_NM")), 11)%></span></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("CAR_ST")%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("RES_ST")%><%=estiGubun%></td>
                  <td <%=td_color%> width='30' align='center'><%if(gubun1.equals("3")){%> - <%}else{%><%=rank%><%}%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("USE_ST")%></td>
                  <td <%=td_color%> width='80' align='center'><%=ht.get("SITUATION_ST")%></td>
                </tr>
        <%		}	%>
            </table>
	    </td>
	    <td class='line' width='1070'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%	
        			for(int i = 0 ; i < cont_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						String td_color = "";
						if(String.valueOf(ht.get("USE_YN")).equals("N")) td_color = " class=is ";
						
				%>
        		<tr>
        		  <td <%=td_color%> width='100' align='center'><!-- 차량현위치 -->
        		  	<%
        		  		String car_no = (String)ht.get("CAR_NO");
	        		  	Vector vt2 = shDb.getCarCurrentArea(car_no);  
	        			int vt2_size = vt2.size();
	        			for(int j = 0 ; j < 1 ; j++){	//<--계약에 따른 차량위치 이므로 가장 최신 한 건만 가져오면 현재위치가 됨.
							Hashtable ht2 = (Hashtable)vt2.elementAt(j);
        		  			String c_a_nm = (String)ht2.get("BR_NM");
	        		  		if(String.valueOf(ht2.get("BR_NM")).equals("") || ht2.get("BR_NM")==null){
	        		  	 %><%-- (<%=ht2.get("BR_ID")%>) --%>
	        		  	 <%}else{%><%=ht2.get("BR_NM")%><%}%>
	        		 <%	}%> 
        		  </td>
        		  <td <%=td_color%> width='100' align='center'>
        		  <% 	String brId = (String)ht.get("BR_ID");
        		  		String branch = ""; 
        		  		
        		  		if(brId.equals("")){
        		  			String est_area = (String)ht.get("EST_AREA1");
        		  			String county = (String)ht.get("EST_AREA2");
        		  			
        		  			
        		  			
        		  			if(est_area.equals("서울시")) 		est_area = "서울";
        		  			if(est_area.equals("부산시")) 		est_area = "부산";
        		  			if(est_area.equals("인천광역시")) est_area = "인천";
        		  			if(est_area.equals("세종특별자치시")) est_area = "세종";
        		  			
        		  			//영업지점8
										if(est_area.equals("서울")){
											if(county.equals("강남구")||county.equals("서초구")||county.equals("성동구")){
												branch = "강남";
											}else if(county.equals("종로구")||county.equals("동대문구")||county.equals("중구")||county.equals("용산구")||county.equals("중랑구")||county.equals("노원구")||county.equals("성북구")||county.equals("서대문구")||county.equals("은평구")||county.equals("도봉구")||county.equals("강북구")) {
												branch = "강북";
											}else if(county.equals("송파구")||county.equals("강동구")||county.equals("광진구")) {
												branch = "송파";
											}else{
												branch = "본사";
											}
										}else if(est_area.equals("인천")){
											branch = "인천";
										}else if(est_area.equals("경기")){
											if(county.equals("과천시")){
												branch = "강남";
											}else if(county.equals("김포시")||county.equals("부천시")||county.equals("시흥시")){
												branch = "인천";
											}else if(county.equals("군포시")||county.equals("수원시")||county.equals("안산시")||county.equals("안성시")||county.equals("여주군")||county.equals("오산시")||county.equals("용인시")||county.equals("의왕시")||county.equals("이천시")||county.equals("평택시")||county.equals("화성시")){
												branch = "수원";
											}else if(county.equals("가평군")||county.equals("성남시")||county.equals("하남시")||county.equals("광주시")||county.equals("남양주시")||county.equals("양평군")||county.equals("구리시")){
												branch = "송파";
											}else if(county.equals("동두천시")||county.equals("양주시")||county.equals("연천군")||county.equals("의정부시")||county.equals("포천시")){
												branch = "강북";
											}else{
												branch = "본사";
											}
										}else if(est_area.equals("강원")){
											if(county.equals("춘천시")||county.equals("양구군")||county.equals("철원군")||county.equals("화천군")||county.equals("홍천군")||county.equals("인제군")||county.equals("고성군")||county.equals("속초시")||county.equals("양양군")){
												branch = "송파";
											}else{
												branch = "수원";
											}
										}else if(est_area.equals("경남")||est_area.equals("부산")||est_area.equals("울산")){
											branch = "부산";
										}else if(est_area.equals("전남")||est_area.equals("광주")||est_area.equals("제주")||est_area.equals("전북")){
											branch = "광주";
										}else if(est_area.equals("대구")||est_area.equals("경북")){
											branch = "대구";
										}else if(est_area.equals("충남")||est_area.equals("충북")||est_area.equals("대전")||est_area.equals("세종")||est_area.equals("세종특별자치시")){
											branch = "대전";
										}
        		  		}
        		  		
        		  		
        		  %>
        		  <%if(String.valueOf(ht.get("RES_ST")).equals("월렌트") ){ // 월렌트 건은 영업지점이 차량 현위치와 동일 %>
       		  		<% for(int j = 0 ; j < 1 ; j++){	//<--계약에 따른 차량위치 이므로 가장 최신 한 건만 가져오면 현재위치가 됨.
						Hashtable ht2 = (Hashtable)vt2.elementAt(j);
	        		  		if( !(String.valueOf(ht2.get("BR_NM")).equals("") || ht2.get("BR_NM")==null ) ){
	        		  	 %>
	        		  	 	<% // 월렌트 중에서도 수도권인 경우에는 고객 주소를 따라가도록. 2021.11.08.
	        		  	 		if(String.valueOf(ht2.get("BR_NM")).equals("수도권")){ 
	        		  	 	%>
	        		  	 		<% if(brId.equals("S1")){ %> 본사
		        		  		<% } else if(brId.equals("B1")){ %>부산 
		        		  		<% } else if(brId.equals("D1")){ %>대전
		        		  		<% } else if(brId.equals("S2")){ %>강남
		        		  		<% } else if(brId.equals("J1")){ %>광주
		        		  		<% } else if(brId.equals("G1")){ %>대구
		        		  		<% } else if(brId.equals("I1")){ %>인천
		        		  		<% } else if(brId.equals("K3")){ %>수원
		        		  		<% } else if(brId.equals("U1")){ %>울산
		        		  		<% } else if(brId.equals("S5")){ %>광화문
		        		  		<% } else if(brId.equals("S6")){ %>송파 
		                  		<% } else{%><%=branch%>
		                  		<% } %>
	        		  	 	<%} else{%>
	        		  	 		<%=ht2.get("BR_NM")%>
	        		  	 	<%}%>
	        		  	 <%}%>
        			<%}%> 
        		  <%} else { // 재리스 %>
        		  		<% if(brId.equals("S1")){ %> 본사
        		  		<% }else if(brId.equals("B1")){ %>부산 
        		  		<% }else if(brId.equals("D1")){ %>대전
        		  		<% }else if(brId.equals("S2")){ %>강남
        		  		<% }else if(brId.equals("J1")){ %>광주
        		  		<% }else if(brId.equals("G1")){ %>대구
        		  		<% }else if(brId.equals("I1")){ %>인천
        		  		<% }else if(brId.equals("K3")){ %>수원
        		  		<% }else if(brId.equals("U1")){ %>울산
        		  		<% }else if(brId.equals("S5")){ %>광화문
        		  		<% }else if(brId.equals("S6")){ %>송파 
                  		<% }else{%><%=branch%>
                  		<% } %>
        		  <%} %>
        		  </td> 
        		  <td <%=td_color%> width='200' align='center'><span title='<%=ht.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("CUST_NM")), 15)%></span></td> 
        		  <td <%=td_color%> width='110' align='center'><span title='<%=AddUtil.phoneFormat(String.valueOf(ht.get("CUST_TEL")))%>'><%=AddUtil.subData(AddUtil.phoneFormat(String.valueOf(ht.get("CUST_TEL"))), 13)%></span></td>
        		  <td <%=td_color%> width='160' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RES_END_DT")))%></td>
        		  <td <%=td_color%> width='250'>&nbsp;<span title='<%=ht.get("MEMO")%>'><%=AddUtil.subData(String.valueOf(ht.get("MEMO")), 20)%></span></td>
        		  <td <%=td_color%> width='70' align='center'><%=ht.get("USER_NM")%></td>
	       		  <td <%=td_color%> width='150' align='left'>
	       		  <% if(!String.valueOf(ht.get("REG_TIME")).equals("")){ %>
	       		  		&nbsp;&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_TIME")))%> <!-- 홈페이지 월렌트 예약건이면 시간까지 다보여줌 -->
	       		  <%		
	       		  	 }else{
	       		  %>		 
	       		  		&nbsp;&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>
	       		  <%		
	       		  	 }
	       		  %>
	       		  </td>
        		</tr>
						<%	}	%>
	        </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='600' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(t_wd.equals("")){%>검색어를 입력하십시오.<%}else{%>등록된 데이타가 없습니다<%}%></td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='850'>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
  	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=cont_size%>';
//-->
</script>
</body>
</html>


