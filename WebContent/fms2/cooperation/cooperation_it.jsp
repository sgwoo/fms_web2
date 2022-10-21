<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");  //주차장방문협조 -> gubun:park
	String idx 	= request.getParameter("idx")  ==null?"1":request.getParameter("idx");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	String seq = "";
	seq = cp_db.getCooperationSeqNext();
	
	
	Vector users = CardDb.getUserSearchListCD("", "", "AA", use_yn); //전체직원 리스트
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("0005", "", "");
	int user_size2 = users2.size();		
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		
		if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		if(fm.content.value == '')		{	alert('내용을 입력하십시오');	return;	}
		
	
		if( fm.out_id.value == ''  && fm.sub_id.value == '' )		{	alert('관리자 또는 업무담당자를 선택하세요');	return;	}
		
		if(get_length(fm.content.value) > 4000){
			alert("내용은 영문4000자/한글2000자 까지만 입력할 수 있습니다.");
			return;
		}
		if(get_length(fm.title.value) > 200){
			alert("내용은 영문200자/한글100자 까지만 입력할 수 있습니다.");
			return;
		}		
		
		if(confirm('등록 하시겠습니까?')){	
		
		if(document.getElementById("file").value != ''){
			file_save();
		}
			fm.action = "cooperation_a.jsp";
			fm.target = 'i_no';
			//fm.target='_blank';
			fm.submit();
		}
	}
	
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}	

	function file_save(){
		var fm2 = document.form2;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm2.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.COOPERATION%>";
		fm2.submit();
	}	
//-->
</script>
</head>

<body>


<table border=0 cellspacing=0 cellpadding=0 width=650>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자문서 > 업무협조 > <span class=style5>IT마케팅팀 업무협조등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<form action='' name="form1" method='post'>
    <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' 	value='<%=user_id%>'>
    <input type='hidden' name='br_id' 	value='<%=br_id%>'>
    <input type='hidden' name='s_year' 	value='<%=s_year%>'>
    <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
    <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
    <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
    <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
    <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
    <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
    <input type='hidden' name='from_page' value='<%=from_page%>'>     
	<input type='hidden' name="seq"	value="<%=seq%>">
    <input type='hidden' name="file_cnt" 	value="2">   
  <input type="hidden" name="use_yn" value="<%=use_yn%>"> 
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
    		<%if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")) { %>
    		    <input type='hidden' name="req_st" value="3" > 
    		<% } else { %> 
				<tr>
					<td class='title' width=15%>요청자구분</td>
					<td>&nbsp;
						<input type='radio' name="req_st" value='5' onClick="javascript:cust_display()" >
							임원 및 팀장&nbsp;
						<input type='radio' name="req_st" value='1' onClick="javascript:cust_display()" checked>
							직원
					</td>
				</tr>
				<% } %>	
				<tr>
					<td class='title' width=15%>업무요청자</td>
					<td>&nbsp;
						<select name='com_id'>
							<option value="">요청자 선택 </option>
							<!-- <option value="000003">대표이사 </option>
							<option value="000004">총무팀장 </option>
							<option value="000005">영업팀장 </option>
							<option value="000026">고객지원팀장 </option>
							<option value="000237">IT마케팅팀팀장 </option> -->
						<%for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
			    			<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    			<%-- <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option> --%>
			    		<%}%>
						</select>
					</td>
				</tr>
				<tr height="50px">
					<td class='title'>제목</td>
					<td>&nbsp;<span style="margin-left: 2px"><b>[IT마케팅팀개발업무]</b></span>
					<input type="hidden" name="title1" value="[IT마케팅팀개발업무]">						
						<br>&nbsp;
					<input type='text' name='title' style='IME-MODE: active' size='80' class='text' maxlength='125'>
					</td>
				</tr>
				<tr>
					<td class='title'><br/><br/>내용<br/><br/></td>
					<td>&nbsp;
						<textarea rows='15' name='content' cols='80' maxlength='2000' style='IME-MODE: active' ></textarea>
					</td>
				</tr>
				<tr>
					<td class='title'>협조부서</td>
					<td>&nbsp;
						<select name='out_id'>
						<option value="000237">IT마케팅팀 </option>
					</select>
					</td>
				</tr>	
					
				<tr>
					<td class='title'>업무담당자</td>
					<td>&nbsp;
						<select name='sub_id'>
						<option value="">담당자 선택</option>
						<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>	
						<%for (int i = 0 ; i < user_size2 ; i++){
							Hashtable user = (Hashtable)users2.elementAt(i);	%>
			    			<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    		<%}%>
						<%}else{%>
						<%if(user_size > 0){
						for (int i = 0 ; i < 1 ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
						<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
						<%}}%>
						<%}%>
					</select>
					</td>
				</tr>								
			</table>
		</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 		
</form>	
<form action='' name="form2" method='post' enctype="multipart/form-data">
	<tr>
		<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
				<tr>
					<td class='title'  width=15%>첨부파일</td>
					<td>&nbsp;
					
						<input type='file' name="file" id="file" size='40' class='text'>
						<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=seq%><%=idx%>' />
						<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.COOPERATION%>' />
						<input type='hidden' name="idx"	value="<%=idx%>">
						<input type='hidden' name="seq"	value="<%=seq%>">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</form>
    <tr>
	<td colspan="2">&nbsp;※ 업무담당자를 정확히 알면 담당자선택, 그렇지 않으면 협조부서의 관리자를 선택하세요.</td>
    </tr>
    <tr>
	<td colspan="2">&nbsp;※ 요청자구분이 고객일때는 완료처리시 지정된 고객 담당자에게 작업완료안내메일이 발송됩니다.</td>
    </tr>	
    <tr>
    	<td align='right'>
    	    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
    	    <!--&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>-->
    	</td>
    </tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>