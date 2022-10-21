<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.fee.*, acar.client.*, acar.cont.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	// 로그인 정보
	String user_id 		= login.getSessionValue(request, "USER_ID");	
	String user_m_tel 	= login.getUser_m_tel(user_id);
	if (user_m_tel == null) {
	    user_m_tel = "";
	}
   	
   	String s_kd 		= request.getParameter("s_kd")		==	null ? "" 	: request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==	null ? "" 	: request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")		==	null ? "" 	: request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")		==	null ? "1" 	: request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")		==	null ? "1" 	: request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")		== 	null ? "" 	: request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")		==	null ? "" 	: request.getParameter("end_dt");
	
	Vector vt = ln_db.getLcEdocMngList(gubun1, gubun4, gubun5, st_dt, end_dt, s_kd, t_wd);
	int vt_size = vt.size();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>FMS - 전자문서 발송</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style type="text/css">
.list-area td{
	text-align: center;
}
.font-1 {
    font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
    font-weight: bold;
}
.font-2 {
    font-family:굴림, Gulim, AppleGothic, Seoul, Arial;
    font-size: 9pt;
}
.width-1 {
    width: 200px;
}
.width-2 {
    width: 250px;
}
.width-3 {
    width: 300px;
    padding: 2px;
    margin-bottom: 3px;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">
	// 검색
	function searchList(){
		var fm = document.form1;
		fm.action = 'lc_doc_mng.jsp';	
		fm.target = '_self';
		fm.submit();
	
	}
	
	// 문서 폐기
	function discardDoc(doc_code){
		
		var check = window.confirm('폐기 시 이전 서명인의 서명 건까지 모두 폐기되며, 재발송을 원하실 경우 전자 문서 발송 메뉴에서 발송 후 처음 서명부터 다시 진행하셔야 합니다.\n\n그래도 폐기하시겠습니까?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.doc_code.value = doc_code;
		fm.type.value = 'discard';
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}
	
	// 서명 완료 전 문서 재발송
	function resendDoc(doc_code){
		var check = window.confirm('기존에 입력하신 수신 정보(메일 계정 또는 연락처)로 재발송됩니다.\n수신 정보 변경을 원하시면 현재 문서를 폐기한 후 전자문서 발송 메뉴에서 재발송하시기 바랍니다.\n\n발송하시겠습니까?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.doc_code.value = doc_code;
		fm.type.value = 'resend';
		
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}
	
	// 서명 완료 문서 결과물 확인용 발송
	function sendCompletedDoc(doc_code){
		var check = window.confirm('서명 완료 문서를 발송하시겠습니까?');
		
		if(!check) return;
		
		var fm = document.form1;
		fm.type.value = 'completed';
		fm.doc_code.value = doc_code;
		
		fm.action = 'e_doc_mng_a.jsp';
		fm.submit();
	}

	// pdf 파일 보기
	function viewFile(end_file){
		window.open(end_file);
	}
	
	//계약서 전송  - (해당 파일 바로 up)
	function file_up(urlfile, m_id, l_cd, rent_st, reg_id){
		
		var fm = document.form1;
		var SUMWIN = "";		
		
		window.open(SUMWIN, "upfile", "left=50, top=50, width=500, height=400, scrollbars=yes, status=yes");		
						
		fm.target = "upfile";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact_edoc.jsp?mrent=N&urlfile="+urlfile+"&m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&reg_id="+reg_id;
		fm.submit();		

	}
	

</script>
</head>
<body style='margin: 0;'>
<form name='form1' action='' method='post'>
<input type='hidden' id='user_id' name='user_id' value='<%=user_id%>' />
<input type='hidden' id='doc_code' name='doc_code' value='' />
<input type='hidden' id='type' name='type' value='' />

<!-- 타이틀 영역 -->
<div style='margin: 0 15px; display: inline-block; '>
	<div class='e-doc-title' >
		<h2>장기 계약서</h2>
	</div>
</div>

<!-- 검색 영역 -->
<div class='search-area' style='margin: 0px 15px;'>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
		</tr>
		<tr>
			<td class=line2></td>
		</tr>
		<tr>
			<td class=line>
				<table border="0" cellspacing="1" cellpadding='0' width=100%>
					<tr>
						<td class="title" width=10%>조회일자</td>
						<td width="40%">&nbsp;
							<select name='gubun4'>
								<option value="1" <%if(gubun4.equals("1"))%>selected<%%>>송신일자</option>
							</select>
							&nbsp;
							<select name='gubun5'>
								<option value="1" <%if(gubun5.equals("1"))%>selected<%%>>당일</option>
								<option value="2" <%if(gubun5.equals("2"))%>selected<%%>>전일</option>
								<option value="3" <%if(gubun5.equals("3"))%>selected<%%>>2일</option>
								<option value="4" <%if(gubun5.equals("4"))%>selected<%%>>당월</option>
								<option value="5" <%if(gubun5.equals("5"))%>selected<%%>>전월</option>
								<option value="6" <%if(gubun5.equals("6"))%>selected<%%>>기간</option>
							</select>
							&nbsp;
							<input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
							~
							<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text">
						</td>
						<td class=title width=10%>구분</td>
						<td width=40%>&nbsp;
							<select name='gubun1'>
								<option value=''  <%if(gubun1.equals("")){ %>selected<%}%>>전체 </option>
								<option value='1' <%if(gubun1.equals("1")){%>selected<%}%>>장기 계약서</option>
								<option value='2' <%if(gubun1.equals("2")){%>selected<%}%>>승계 계약서</option>
								<option value='3' <%if(gubun1.equals("3")){%>selected<%}%>>연장 계약서</option>
							</select>&nbsp;
						</td>
					</tr>
					<tr>
						<td class=title width=10%>검색조건</td>
						<td colspan='3'>&nbsp;
							<select name='s_kd'>
								<option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호</option>
								<option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호</option>
								<option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호</option>
								<option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>차명</option>
								<option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>송신자</option>
							</select>
							&nbsp;
							<input type='text' name='t_wd' size='30' class='text' value='<%=t_wd%>'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr align="right">
			<td>
				<a href="javascript:searchList();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
			</td>
		</tr>
	</table>
</div>

<!-- 리스트 영역 -->
<div class='list-area' style='margin: 0px 15px;'>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
		    <td class=h></td>
		</tr>
		<tr>
	        <td class=line2></td>
	    </tr>
	    <tr>
	    	<td class='line'>
	    	<table border=0 cellspacing=1 width=100%>
	    		<tr>
	    			<td class='title title_border' rowspan='2'>연번</td>
	    			<td class='title title_border' rowspan='2'>문서명</td>
	    			<td class='title title_border' rowspan='2'>계약구분</td>
	    			<td class='title title_border' rowspan='2'>계약번호</td>
	    			<td class='title title_border' rowspan='2'>상호</td>
	    			<td class='title title_border' colspan='2'>자동차</td>
	    			<td class='title title_border' rowspan='2'>송신자</td>
	    			<td class='title title_border' rowspan='2'>송신일자</td>
	    			<td class='title title_border' rowspan='2'>유효기간</td>
	    			<td class='title title_border' rowspan='2'>처리</td>
	    			<td class='title title_border' rowspan='2'>전송구분</td>
	    			<td class='title title_border' rowspan='2'>서명자구분</td>
	    			<td class='title title_border' rowspan='2'>서명구분</td>
	    			<td class='title title_border' rowspan='2'>완료일자</td>
	    			<td class='title title_border' colspan='2'>파일</td>
	    			<td class='title title_border' rowspan='2'>폐기</td>
	    			<td class='title title_border' rowspan='2'>재발송</td>
	    			<td class='title title_border' rowspan='2'>완료문서<br>발송</td>
	    		</tr>
	    		<tr>
	    			<td class='title title_border'>차명</td>
	    			<td class='title title_border'>차량번호</td>
	    			<td class='title title_border'>PDF 파일</td>
	    			<td class='title title_border'>스캔등록</td>
	    		</tr>
	    		<%if(vt_size > 0){ %>
	    			<%for(int i=0; i<vt_size; i++){ 
	    				Hashtable ht = (Hashtable)vt.elementAt(i);
	    			%>
		    		<tr>
		    			<td><%=i+1%></td>
		    			<td><%=ht.get("DOC_NAME")%></td>
		    			<td><%=ht.get("RENT_TYPE")%></td>
		    			<td><%=ht.get("RENT_L_CD")%></td>
		    			<td><%=ht.get("FIRM_NM")%></td>
		    			<td><%=ht.get("CAR_NM")%></td>
		    			<td><%=ht.get("CAR_NO")%></td>
		    			<td><%=ht.get("USER_NM")%></td>
		    			<td><%=ht.get("REG_DT")%></td>
		    			<td><%=ht.get("TERM_DT")%></td>
		    			<td><%=ht.get("USE_YN")%></td>
		    			<td><%=ht.get("SEND_TYPE")%></td>
		    			<td><%=ht.get("SIGN_ST")%></td>
		    			<td><%=ht.get("SIGN_TYPE")%></td>
		    			<td><%=ht.get("END_DT")%></td>
		    			<td><!-- PDF 파일 보기 -->
		    				<%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("") ){  // 서명 완료 후 PDF 파일 생성된 건만 버튼 노출  %>
		    					<input type='button' class='button' value='보기' onclick="javascript:viewFile('<%=ht.get("END_FILE")%>');" />
		    				<%} %>	
		    		    </td>
		    		    <td><!-- 파일 스캔 등록 -->
		    		    <%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("") ){  // 서명 완료 후 PDF 파일 생성된 건만 버튼 노출  %>		
		    			 <% if (nm_db.getWorkAuthUser("전산팀",user_id)) { %> <!--  ht.get("FEE_RENT_ST")  -->
		    				    &nbsp;<input type="button" class="button" id='downfile' value='스캔등록' onclick="javascript:file_up('<%=ht.get("END_FILE")%>','<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>', '<%=user_id%>')">	  
		    			 <% } %>
		    			<%} %>					    			
		    			</td>
		    			<td>	<!-- 폐기 -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("등록") ){ %>
		    					<%if( String.valueOf(ht.get("END_DT")).equals("") ){ // 서명 완료되지 않은 건만 버튼 노출 %>
			    				<input type='button' class='button' value='폐기' onclick="javascript:discardDoc('<%=ht.get("DOC_CODE")%>');" />
			    				<%} %>
		    				<%} %>
		    			</td>
		    			<td>	<!-- 서명 완료 전 재발송 -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("등록") ){ %>
			    				<%if( String.valueOf(ht.get("END_DT")).equals("") ){ // 서명 완료되지 않은 건만 버튼 노출 %>
			    				<input type='button' class='button' value='재발송' onclick="javascript:resendDoc('<%=ht.get("DOC_CODE")%>');" />
			    				<%} %>
		    				<%} %>
		    			</td>
		    			<td>	<!-- 완료 문서 발송 -->
		    				<%if( String.valueOf(ht.get("USE_YN")).equals("등록") ){ %>
		    					<%if( !String.valueOf(ht.get("END_DT")).equals("") && !String.valueOf(ht.get("END_FILE")).equals("")){ // 서명 완료 후 PDF 파일 생성된 건만 버튼 노출 %>
		    					<input type='button' class='button' value='발송' onclick="javascript:sendCompletedDoc('<%=ht.get("DOC_CODE")%>');" />
		    					<%} %>
		    				<%} %>
		    			</td>
		    		</tr>
	    			<%} %>
	    		<%}else{ %>
	  			<tr>
					<td class='center content_border' colspan='20' style='text-align: center;'>등록된 데이터가 없습니다</td>
				</tr>	
	    		<%} %>
	    	</table>
	    	</td>
	    </tr>
	</table>
</div>
</form>
</body>

</html>
