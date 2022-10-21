<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.util.*,acar.client.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
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
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");  // 계약에서 넘어오는 경우  
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");  // 계약에서 넘어오는 경우  
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");  //주차장방문협조 -> gubun:park
	String idx 	= request.getParameter("idx")  ==null?"1":request.getParameter("idx");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	String seq = "";
	seq = cp_db.getCooperationSeqNext();
	
	Vector users = c_db.getUserList("", "", "EMP"); //전체직원 리스트
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("0005", "", "");
	int user_size2 = users2.size();	
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);	
	String stitle =  rent_l_cd + " "+ client.getFirm_nm();
	
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
		
		if(fm.title1.value == '')		{	alert('항목을 선택하세요');	return;	}
		if(fm.title.value == '')		{	alert('제목을 입력하십시오');	return;	}
		if(fm.content.value == '')		{	alert('내용을 입력하십시오');	return;	}
						
		if (fm.from_page.value == "/fms2/cooperation/cooperation_it_sc.jsp" ) {
				
		} else if (fm.from_page.value == "/fms2/lc_rent/lc_s_frame.jsp" ) {
			if(fm.title1.value == '[운행정지명령신청요청]' )  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("본사관리팀장")%>';
		  
		} else {
			if(fm.req_st[1].checked == true){
				
				if(fm.email_1.value != '' && fm.email_2.value != ''){
					fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
				}
				
				if(fm.agnt_m_tel.value == '' && fm.agnt_email.value == ''){
					alert('고객요청인 경우에는 완료메시지를 받을 이동전화번호 혹은 이메일주소가 있어야 합니다.'); return;
				}
				if(fm.title1.value == '[세금계산서]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("세금계산서담당자")%>';
				if(fm.title1.value == '[보험]' && fm.sub_id.value == '')  			fm.sub_id.value = '<%=nm_db.getWorkAuthUser("대전보험담당")%>';
				if(fm.title1.value == '[사업자등록증변경]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("세금계산서담당자")%>';
				if(fm.title1.value == '[과태료]' && fm.sub_id.value == '')  			fm.sub_id.value = '<%=nm_db.getWorkAuthUser("과태료담당자")%>';
				if(fm.title1.value == '[카드입금처리요청]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("입금담당")%>';
			}
		}
		
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
			file_save();
			fm.action = "cooperation_a.jsp";
			fm.target = 'i_no';
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
	
	//고객 조회
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/cooperation/cooperation_i.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("/fms2/lc_rent/search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value+"&from_page=/fms2/cooperation/cooperation_i.jsp", "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
		
	//요청자구분
	function cust_display(){
		var fm = document.form1;
		if(fm.req_st[0].checked == true){ 				//직원
			tr_cust1.style.display	= 'none';
			tr_cust2.style.display	= 'none';
		}else{											//고객
			tr_cust1.style.display	= '';
			tr_cust2.style.display	= '';
		}
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
<form action='' name="form2" method='post' enctype="multipart/form-data">
	<input type='hidden' name="idx"	value="<%=idx%>">
	<input type='hidden' name="seq"	value="<%=seq%>">
</form>
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
<table border=0 cellspacing=0 cellpadding=0 width=650>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>전자문서 > 업무협조 > <span class=style5>업무협조등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
    	<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
    		<%if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")) { %>
    		    <input type='hidden' name="req_st" value="3" > 
    		<% } else { %> 
		<tr>
		    <td class='title' width=15%>요청자구분</td>
		    <td>&nbsp;
			<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
			<input type='radio' name="req_st" value='5' onClick="javascript:cust_display()" checked >
				임원 및 팀장
			<%}else if (from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")){%> 
			<input type='radio' name="req_st" value='1'  checked >
				직원
			<%}else { %>
			<input type='radio' name="req_st" value='1' onClick="javascript:cust_display()" <%if(!from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp"))%>checked<%%>>
        		직원
        		<input type='radio' name="req_st" value='2' onClick="javascript:cust_display()" <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp"))%>checked<%%>>
        		고객        				        				
			<%}%>
		    </td>
		</tr>
		<% } %>	
		<tr>
		    <td class='title' width=15%>등록자</td>
		    <td>&nbsp;
		        <%=c_db.getNameById(user_id, "USER")%></td>
		</tr>
		<tr>
		    <td class='title'>제목</td>
		    <td>&nbsp;
		        <select name='title1'>
                    	    <option value="">선택</option>
			    <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){ //고객업무협조%>						                    	
                    	    <option value="[세금계산서]">[세금계산서]</option>                    
                    	    <option value="[보험]">[보험]</option>
                    	    <option value="[사업자등록증변경]">[사업자등록증변경]</option>
                    	    <option value="[과태료]">[과태료]</option>
			    <%}else if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")){//주차장방문협조%>		
			    <option value="[주차장방문협조]">[주차장방문협조]</option>
				<%}else if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){//주차장방문협조%>		
			    <option value="[IT마케팅팀개발업무]" selected>[IT마케팅팀개발업무]</option>
			   	<%}else if(from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")){//주차장방문협조%>		
			     <option value="[운행정지명령신청요청]">[운행정지명령신청요청]</option>	
			     <option value="[내용증명발송요청]">[내용증명발송요청]</option>    		
			     
			    <%}else{//업무협조%>
                    	    <option value="[카드입금처리요청]">[카드입금처리요청]</option>
                    	    <option value="[자동차등록요청]">[자동차등록요청]</option>
                    	    <option value="[계약서작성요청]">[계약서작성요청]</option>
                    	    <option value="[당직변경요청]">[당직변경요청]</option>
                    	    <option value="[통장변경요청]">[통장변경요청]</option>
                    	    <option value="[계약관련변경요청]">[계약관련변경요청]</option>
                    	    <option value="[초본신청요청]">[초본신청요청]</option>
                    	    <option value="[미제출서류]">[미제출서류]</option>
                    	    <option value="[신용조회요청]">[신용조회요청]</option>	
                    	    <option value="[과태료처리요청]">[과태료처리요청]</option>	
                    	   			
			    <%}%>
                    	    <option value="[기타]">[기타]</option>                                         	
                  	</select><br>
			&nbsp;
			<input type='text' name='title' value='<%=stitle%>' style='IME-MODE: active' size='80' class='text' maxlength='125'>
		    </td>
		</tr>
		<tr>
		    <td class='title'><br/><br/>내용<br/><br/></td>
		    <td>&nbsp;
		        <textarea rows='15' name='content' cols='80' maxlength='2000' style='IME-MODE: active' ></textarea></td>
		</tr>
		<tr>
		    <td class='title'>첨부파일</td>
		    <td>&nbsp;
			
				<input type='file' name="file" size='40' class='text'>
				<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=seq%><%=idx%>' />
				<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.COOPERATION%>' />
			
			</td>
		</tr>
		<tr>
		    <td class='title'>협조부서</td>
		    <td>&nbsp;
		        <select name='out_id'>
				<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>	
				<option value="000237">IT마케팅팀팀장 </option>
				<%}else{%>
			    <option value="">관리자 선택 </option>
			    <option value="000004">총무팀장 </option>
			    <option value="000005">영업팀장 </option>
			    <option value="000026">고객지원팀장 </option>
				<option value="000237">IT마케팅팀팀장 </option>
			    <option value="000053">제인학 </option>
			    <option value="000052">박영규 </option>
			    <option value="000054">윤영탁 </option>
			    <option value="000219">류선 </option>
				<%}%>
			</select>
			    (업무담당자를 모를 때)
		    </td>
		</tr>				
		<tr>
		    <td class='title'>업무담당자</td>
		    <td>&nbsp;
		        <select name='sub_id'>
				<option value="">담당자 선택</option>
				<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
				<%	if(user_size2 > 0){
						for (int i = 0 ; i < user_size2 ; i++){
						Hashtable user = (Hashtable)users2.elementAt(i);	%>
			    <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    <%	}}%>					
				<%}else{%>
			    <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);	%>
			    <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    <%	}}%>
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
    <tr id=tr_cust1 <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
        <td class=line2></td>
    </tr>
    <tr id=tr_cust2 <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
    	<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
		<tr>
		    <td class='title' width=15%>고객</td>
		    <td>&nbsp;
		        <input type='text' name="firm_nm" value='' size='50' class='text' readonly>
        	        <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        		<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>		
			<input type='hidden' name='client_id' value=''>
		    </td>
		</tr>
		<tr>
		    <td class='title'>담당자</td>
		    <td>&nbsp;
		        <input type='text' name='agnt_nm'    size='20' class='text' style='IME-MODE: active'>
			<span class="b"><a href='javascript:search_mgr(0)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
			(직접 입력 가능)
		    </td>
		</tr>
		<tr>
		    <td class='title'>이동전화</td>
		    <td>&nbsp;
		        <input type='text' name='agnt_m_tel'    size='20' class='text' style='IME-MODE: active'></td>
		</tr>
		<tr>
		    <td class='title'>이메일</td>
		    <td>&nbsp;
		        <input type='text' size='15' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
			<select id="email_domain" onChange="javascript:document.form1.email_2.value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="paran.com">paran.com</option>
						<option value="yahoo.com">yahoo.com</option>
						<option value="korea.com">korea.com</option>
						<option value="hotmail.com">hotmail.com</option>
						<option value="chol.com">chol.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hanafos.com">hanafos.com</option>
						<option value="lycos.co.kr">lycos.co.kr</option>
						<option value="dreamwiz.com">dreamwiz.com</option>
						<option value="unitel.co.kr">unitel.co.kr</option>
						<option value="freechal.com">freechal.com</option>
                        <option value="empal.com">empal.com</option>
						<option value="">직접 입력</option>
			</select>
			<input type='hidden' name='agnt_email' value=''>
			<!--<input type='text' name='agnt_email'    size='50' class='text' style='IME-MODE: active'>-->
		    </td>
		</tr>
	    </table>
	</td>
    </tr>	
    <tr>
	<td class=h></td>
    </tr>
    <tr>
	<td colspan="2">&nbsp;※ 업무담당자를 정확히 알면 담당자선택, 그렇지 않으면 협조부서의 관리자를 선택하세요.</td>
    </tr>
    <tr>
	<td colspan="2">&nbsp;※ 요청자구분이 고객일때는 완료처리시 지정된 고객 담당자에게 작업완료안내메일이 발송됩니다.</td>
    </tr>	
    <tr>
	<td colspan="2">&nbsp;※ 주차장방문요청인 경우 선택된 주차관리담당자에게 SMS를 보냅니다.</td>
    </tr>	
    <tr>
    	<td align='right'>
    	    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
    	    <!--&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>-->
    	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>