<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cooperation.*, acar.client.*, acar.im_email.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String s_seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	cp_bean = cp_db.getCooperationBean(seq);
	
	Vector users = new Vector();
	
	if(cp_bean.getOut_id().equals("000004")){
		users = c_db.getUserListCooperation("", "", "DEPT3","Y"); // 총무팀장
	}else if(cp_bean.getOut_id().equals("000005")){
		users = c_db.getUserListCooperation("", "", "DEPT1","Y"); // 영업팀장
	}else if(cp_bean.getOut_id().equals("000026")){
		users = c_db.getUserListCooperation("", "", "DEPT2","Y"); // 관리팀장
	}else if(cp_bean.getOut_id().equals("000053")){	
		users = c_db.getUserListCooperation("", "", "DEPT7","Y"); // 부산지점장
	}else if(cp_bean.getOut_id().equals("000052")){	
		users = c_db.getUserListCooperation("", "", "DEPT8","Y"); // 대전지점장
	}else if(cp_bean.getOut_id().equals("000054")){	
		users = c_db.getUserListCooperation("", "", "DEPT9","Y"); // 대구지점장
	}else if(cp_bean.getOut_id().equals("000052")){	
		users = c_db.getUserListCooperation("", "", "DEPT10","Y"); // 광주지점장
	}else{
		users = c_db.getUserList("", "", "EMP"); //전체직원 리스트
	}
	
	Vector users2 = c_db.getUserList("0005", "", ""); //IT팀 리스트
	
	int user_size = users.size();
	int user_size2 = users2.size();
	
	//고객정보
	ClientBean client = al_db.getNewClient(cp_bean.getClient_id());
	
	//완료안내메일
	Vector im_vt =  ImEmailDb.getFmsInfoMailDocSendList(seq+"cooperation", cp_bean.getClient_id());
	int im_vt_size = im_vt.size();
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_year="+s_year+"&s_mon="+s_mon+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&mode="+mode+"&from_page="+from_page;
	
	String title_gubun = "";
	if(cp_bean.getTitle().length() > 11){	title_gubun = cp_bean.getTitle().substring(1,11); }
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "COOPERATION";
	String content_seq  = s_seq;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	String file_type2 = "";
	String seq2 = "";
	String file_name2 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq+1).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+2).equals(aht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(aht.get("FILE_NAME"));
			file_type2 = String.valueOf(aht.get("FILE_TYPE"));
			seq2 = String.valueOf(aht.get("SEQ"));

		}
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	var popObj = null;
	
	
	function save()
	{
		var fm = document.form1;

		if(confirm('수정 하시겠습니까?')){		
			<%if(cp_bean.getReq_st().equals("2")){%>
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}
			<%}%>
			fm.cmd.value = "u";
			fm.action = "cooperation_u_a.jsp";	
			fm.target='i_no';
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
	
	//요청처리
	function ed_time_in()
	{
		var fm = document.form1;	
		
		if(fm.out_content.value == '')		{	alert('처리결과를 입력하십시오');	return;	}

		if(fm.req_st.value == '2'){
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}
			if(fm.agnt_m_tel.value == '' && fm.agnt_email.value == ''){
				alert('고객요청인 경우에는 완료메시지를 받을 이동전화번호 혹은 이메일주소가 있어야 합니다.'); return;
			}
		}
					
		if(fm.title.value.indexOf('[미제출서류]') != -1){
			fm.from_page.value = 'lc_n_memo.jsp';
		}
		if(confirm('처리완료 하시겠습니까?')){				
			fm.action='cooperation_end_a.jsp';		
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}
	}	

	//이메일재발송	
	function Remail(){
		var fm = document.form1;		
				
		if(confirm('메일을 재발행 하시겠습니까?')){
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}
			fm.action='cooperation_remail_a.jsp';		
			fm.target = 'i_no';
			fm.submit();		
		}			
	}

	//처리자 배정
	function sub_input()
	{
		var fm = document.form1;
		if(confirm('처리담당자를 배정 하시겠습니까?')){
			fm.action='cooperation_sub_a.jsp';		
			fm.target='i_no';
//			fm.target='_blank';
			fm.submit();
		}
	}	

	//삭제
	function del()
	{
		var fm = document.form1;
		if(confirm('삭제 하시겠습니까?')){		
			fm.action='cooperation_d_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}	
	
	//스캔등록
	function scan_reg(idx){
		window.open("reg_scan.jsp?idx="+idx+"&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&seq=<%=seq%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

	//스캔삭제
	function scan_del(idx){
		var theForm = document.form1;
		theForm.remove_idx.value =idx;
		
		if(!confirm('삭제하시겠습니까?')){		return;	}
		
		theForm.action = "https://fms3.amazoncar.co.kr/acar/upload/coop_del_scan_a.jsp";
		theForm.target = "i_no";
		theForm.submit();		
	}
		
	//팝업윈도우 열기
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/coop/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
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
	
	function lc_rent_busid2_cng(){
		var fm = document.form1;
		if(fm.rent_l_cd.value == ""){ alert("계약번호가 정확하지 않습니다."); return;}	
		window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item=bus_id2&rent_l_cd="+fm.rent_l_cd.value, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
	}
	
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
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
  <input type='hidden' name='seq' 		value='<%=seq%>'>
  <input type='hidden' name='cmd' 		value=''>
  <input type="hidden" name="req_st" 	value="<%=cp_bean.getReq_st()%>">	
  <input type="hidden" name="com_id" 	value="<%=cp_bean.getCom_id()%>">


<table border=0 cellspacing=0 cellpadding=0 width=650>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 영업지원 > <span class=style5><%if(cp_bean.getReq_st().equals("2")){%>고객<%}%>업무협조</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
    	<td align='right'>		   
    		<%	if(cp_bean.getSub_id().equals("") || cp_bean.getIn_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)|| nm_db.getWorkAuthUser("채권관리팀",user_id)){%>
			<%		if(!mode.equals("view")){%>
			<%			if(cp_bean.getOut_dt().equals("")){%>
			<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>						
			&nbsp;&nbsp;
			<a href='javascript:del()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			<%			}%>
			<%}%>
			<%	}%>
			 &nbsp;
    		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
    	</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
				<tr>
					<td class='title' width=100>요청자구분</td>
					<td>&nbsp;
					  <%if(cp_bean.getReq_st().equals("1") || cp_bean.getReq_st().equals("")){%>직원<%}%>
					  <%if(cp_bean.getReq_st().equals("2")){%>고객<%}%>			
					  <%if(cp_bean.getReq_st().equals("5")){%>임원 및 팀장<%}%>							  
					</td>
				</tr>			
			    <tr>
			    	<td class='title' width='100'>요청일자</td>
			    	<td>&nbsp;<%= AddUtil.ChangeDate2(cp_bean.getIn_dt()) %></td>
			    </tr>
			    <tr>
			    	<td class='title'><%if(cp_bean.getReq_st().equals("2")){%>접수자<%}else{%>요청직원<%}%></td>
			    	<td>&nbsp;
						<%-- <%if(cp_bean.getReq_st().equals("5")){%>
							<%=c_db.getNameById(cp_bean.getCom_id(),"USER")%>
						<%}else{%> --%>
							<%=c_db.getNameById(cp_bean.getCom_id(),"USER")%>
						<%-- <%}%> --%>
					</td>
			    </tr>
			    <tr>
			    	<td class='title'>제 &nbsp;&nbsp;&nbsp; 목</td>
			    	<td>&nbsp;<input type='text' name='title' value='<%=cp_bean.getTitle()%>' style='IME-MODE: active' size='80' class='<%if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp") || title_gubun.equals("소액채권대손처리요청")){%>white<%}%>text' maxlength='125'></td>
			    </tr>
				<tr>
			    	<td class='title'><br/><br/>업무협조<br>내 &nbsp;&nbsp;&nbsp; 용<br/><br/></td>
			    	<td>&nbsp;<textarea rows='8' name='content' cols='80' maxlength='2000' style='IME-MODE: active'><%=cp_bean.getContent()%></textarea></td>
			    </tr>
				<tr>
			    	<td class='title'>첨부파일1</td>
			    	<td>&nbsp;
						<%if(!cp_bean.getFile_name1().equals("")){%>
							<a href="javascript:MM_openBrWindow('<%= cp_bean.getFile_name1() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= cp_bean.getFile_name1() %></a>&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:scan_del('1')"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
						<%}else{%>
							<%if(file_name1.equals("")){%>
								<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%}%>
					  </td>
			    </tr>
				<tr>
			    	<td class='title'>첨부파일2</td>
			    	<td>&nbsp;
					  <%if(!cp_bean.getFile_name2().equals("")){%>
							<a href="javascript:MM_openBrWindow('<%= cp_bean.getFile_name2() %>','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50')"><%= cp_bean.getFile_name2() %></a>&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:scan_del('2')"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
						<%}else{%>
							<%if(file_name2.equals("")){%>
								<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a> 
							<%}else{%>
								<%if(file_type2.equals("image/jpeg")||file_type2.equals("image/pjpeg")||file_type2.equals("application/pdf")){%>
									<a href="javascript:openPopF('<%=file_type2%>','<%=seq2%>');" title='보기' ><%=file_name2%></a>
								<%}else{%>
									<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq2%>" target='_blank'><%=file_name2%></a>
								<%}%>
							 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq2%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
						<%}%>
					</td>
			    </tr>				
			    <tr>
			    	<td class='title'>업무협조<br>처리결과</td>
			    	<td>&nbsp;<textarea rows='6' name='out_content' cols='80' maxlength='2000' style='IME-MODE: active'><%=cp_bean.getOut_content()%></textarea></td>
			    </tr>
				<%	if(cp_bean.getSub_id().equals("")){%>
				<tr>
					<td class='title'>협조부서</td>
					<td>&nbsp;
					<%	if(cp_bean.getOut_id().equals("")){%>
					<select name='out_id'>
						<option value="">관리자 선택 </option>
						<option value="000004" <%if(cp_bean.getOut_id().equals("000004")){%>selectec<%}%>>총무팀장 </option>
						<option value="000005" <%if(cp_bean.getOut_id().equals("000005")){%>selectec<%}%>>영업팀장 </option>
						<option value="000026" <%if(cp_bean.getOut_id().equals("000026")){%>selectec<%}%>>고객지원팀장 </option>
						<option value="000053" <%if(cp_bean.getOut_id().equals("000053")){%>selectec<%}%>>부산지점장 </option>
						<option value="000052" <%if(cp_bean.getOut_id().equals("000052")){%>selectec<%}%>>대전지점장 </option>
						<option value="000054" <%if(cp_bean.getOut_id().equals("000054")){%>selectec<%}%>>대구지점장 </option>
						<option value="000052" <%if(cp_bean.getOut_id().equals("000052")){%>selectec<%}%>>광주지점장 </option>
					<%	}else{%>	
					<%=c_db.getNameById(cp_bean.getOut_id(),"USER")%><input type='hidden' name='out_id' value='<%=cp_bean.getOut_id()%>'>
					<%	}%>
					</td>
				</tr>	
				<%}else{%>
				<input type='hidden' name='out_id' value='<%=cp_bean.getOut_id()%>'>
				<%}%>
			  <tr>
			    	<td class='title'>처리담당자</td>
					<td>&nbsp;					
					<%	if(cp_bean.getSub_id().equals("")){%>
						<select name='sub_id'>
							<option value="">담당자 선택</option>
							<%	if(user_size > 0){
									for (int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i);	%>
									<option value='<%=user.get("USER_ID")%>' <%if(cp_bean.getOut_id().equals(user.get("USER_ID"))){ out.println("selected"); }%>><%=user.get("USER_NM")%></option>
							<%		}
								}%>
						</select>&nbsp;&nbsp;&nbsp;
						<a href='javascript:sub_input()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>					
					<%	}else{%>
					<%=c_db.getNameById(cp_bean.getSub_id(),"USER")%>
					<%		if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp") || title_gubun.equals("소액채권대손처리요청")){%>
					<%		}else{%>
					<%			if(cp_bean.getOut_dt().equals("") && (nm_db.getWorkAuthUser("전산팀",user_id))){%>
					&nbsp;&nbsp;* 담당자 변경 : 
						<select name='sub_id'>
							<option value="">담당자 변경</option>
					<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>	
							<%for (int i = 0 ; i < user_size2 ; i++){
								Hashtable user = (Hashtable)users2.elementAt(i);	%>
			    				<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    		<%}%>
					<%}else{%>
					    <%if(user_size > 0){
								for (int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i);	%>
							<option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
					    	<%}
							}%>
					<%}%>
						</select>&nbsp;&nbsp;&nbsp;
						<a href='javascript:sub_input()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>										
					<%			}else{%>
							<input type='hidden' name='sub_id' value='<%=cp_bean.getSub_id()%>'>
					<%			}%>
					<%		}%>
					<%	}%>
					</td>					
			    </tr>
				<%if(cp_bean.getReq_st().equals("2")){%>
				<tr>
			    	<td class='title'>고객</td>
			    	<td>
					  <table border=0 cellspacing=1 cellpadding=0 width=100%>
                        <tr>
	                      <td width=80>&nbsp;상호</td>
	                      	<td>:&nbsp;
							  <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='whitetext' readonly>
							  <%	if(cp_bean.getOut_dt().equals("")){%>
							  <!--
        			  			<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  			<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>		
							  -->	
							  <%	}%>	
					  		  <input type='hidden' name='client_id' value='<%=cp_bean.getClient_id()%>'>
					  		  
					  		  <br>&nbsp;&nbsp;
					  		  <%if(!client.getClient_st().equals("2")){%>
					  		  (사업자번호 : <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>)
					  		  <%}else{%>
					  		  (생년월일 : <%=client.getSsn1()%>)
					  		  <%}%>
					  		  
					  		  
					  		  </td>
                        </tr>
                        <tr>
	                      	<td>&nbsp;담당자</td>
	                      	<td>:&nbsp;
							  <input type='text' name='agnt_nm' value='<%=cp_bean.getAgnt_nm()%>' size='20' class='text' style='IME-MODE: active'>
							  <%	if(cp_bean.getOut_dt().equals("") && cp_bean.getAgnt_nm().equals("")){%>							  							  
							  <span class="b"><a href='javascript:search_mgr(0)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
								(직접 입력 가능)							  
							  <%	}%>									
							  </td>
                        </tr>
                        <tr>
	                      	<td>&nbsp;이동전화</td>
	                      	<td>:&nbsp;
							  <input type='text' name='agnt_m_tel' value='<%=cp_bean.getAgnt_m_tel()%>' size='20' class='text' style='IME-MODE: active'></td>
                        </tr>
						<%	String email_1 = "";
							String email_2 = "";
							if(!cp_bean.getAgnt_email().equals("")){
								int mail_len = cp_bean.getAgnt_email().indexOf("@");
								if(mail_len > 0){
									email_1 = cp_bean.getAgnt_email().substring(0,mail_len);
									email_2 = cp_bean.getAgnt_email().substring(mail_len+1);
								}
							}
						%>										
                        <tr>
	                      	<td>&nbsp;이메일</td>
	                      	<td>:&nbsp;
							  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  			<select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
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
								  <option value="">직접 입력</option>
					  		    </select>
					  		  <input type='hidden' name='agnt_email' value='<%=cp_bean.getAgnt_email()%>'>
							  <!--<input type='text' name='agnt_email' value='<%=cp_bean.getAgnt_email()%>' size='50' class='text' style='IME-MODE: active'>-->							  
  							  <%if(!cp_bean.getOut_dt().equals("")){%>
							  &nbsp;&nbsp;<a href="javascript:Remail();"><img src="/acar/images/center/button_jbh.gif" align="absmiddle" border="0"></a>
							  <%}%>
							</td>
                        </tr>
                      </table>
			    	</td>
			    </tr>								
				<tr>
			    	<td class='title'>처리완료일</td>
			    	<td>&nbsp;
			    		<%	if(cp_bean.getOut_dt().equals("")){%>
						<%		if(!mode.equals("view")){%>
						<%			if(cp_bean.getSub_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
						<a href='javascript:ed_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>						
						※ 업무협조 처리결과내용 입력후 등록버튼을 클릭하면 등록됩니다.
						<%			}%>
						<%		}%>						
						<%	}else{%>
						<input type="text" name="out_dt" value="<%=cp_bean.getOut_dt()%>" class='text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>[처리완료]</font>
						<%	}%>
			    	</td>
			    </tr>				
				<%}else{%>
				<tr>
			    	<td class='title'><%if(cp_bean.getOut_dt().equals("")){%>처리완료 등록<%}else{%>처리완료일<%}%></td>
			    	<td>&nbsp;
			    		<%	if(cp_bean.getOut_dt().equals("")){%>
						<%		if(!mode.equals("view")){%>
						<%			if(cp_bean.getSub_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
						<a href='javascript:ed_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a>						
						※ 업무협조 처리결과내용 입력후 등록버튼을 클릭하면 등록됩니다.
						<%			}%>
						<%		}%>						
						<%	}else{%>
						<%-- <input type="text" name="out_dt" value="<%=cp_bean.getOut_dt()%>" class='text'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color=red>[처리완료]</font> --%>
						<%=AddUtil.ChangeDate3(cp_bean.getOut_dt())%>&nbsp;<font color=red>[처리완료]</font>
						<%	}%>
			    	</td>
			    </tr>
				
				<%}%>				
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;※ 요청자구분이 고객일때는 완료처리시 지정된 고객 담당자에게 요청완료안내메일이 발송됩니다.</td>
	</tr>	
	<tr>
		<td colspan="2">&nbsp;※ <b>이메일</b>에 처리결과가 보여지므로 <b>주민등록번호 등 보안</b>이 필요한 내용은 입력하지 말아야 합니다.</td>
	</tr>		
	<%if(cp_bean.getReq_st().equals("2")){%>
	<%		if(im_vt_size > 0){%>			
	<tr> 
        <td class=line2 colspan=2></td>
    </tr>		
    <tr>
        <td colspan="2" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width="29%" class='title'>이메일주소</td>
                    <td width="23%" class='title'>발송일시</td>
                    <td width="23%" class='title'>열람일시</td>
                    <td width="10%" class='title'>수신여부</td>
                    <td width="10%" class='title'>발송상태</td>
                </tr>
              <%	for(int i = 0 ; i < im_vt_size ; i++){
    				      Hashtable ht = (Hashtable)im_vt.elementAt(i);%>		  
                <tr>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("EMAIL")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
                    <td align='center'><%=ht.get("OCNT_NM")%></td>
                    <td align='center'><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>
                </tr>
              <%	}%>				  
            </table>
        </td>
    </tr>	
	<%		}%>	
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
    	<td align='center'>		   
			<a href="http://fms1.amazoncar.co.kr/mailing/ask/re_ask.jsp?seq=<%=seq%>" target="_blank" onFocus="this.blur();" title='이메일확인'><img src=/acar/images/center/button_e_email.gif align=absmiddle border=0></a>
    	</td>
    </tr>	
	<%}%>
	
	<%	
		%>
	
	<%	if(cp_bean.getOut_dt().equals("")){%>		
	<%		if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp") || title_gubun.equals("소액채권대손처리요청")){%>
	<%			if(user_id.equals(cp_bean.getSub_id()) || nm_db.getWorkAuthUser("전산팀",user_id)){%>	
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
    	<td>		   
			&nbsp;※ 계약번호 : <input type='text' name="rent_l_cd" value='' size='20' class='text'> <a href='javascript:lc_rent_busid2_cng()' border='0' title='영업담당자변경'><img src=/acar/images/center/button_modify_yuddj.gif align=absmiddle border=0></a>
    	</td>
    </tr>	
	<%			}%>	
	<%		}%>		
	<%	}%>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language="JavaScript">
<!--	
	<%	if(cp_bean.getOut_dt().equals("")){%>		
	<%		if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp") || title_gubun.equals("소액채권대손처리요청")){%>
	<%			if(user_id.equals(cp_bean.getSub_id()) || nm_db.getWorkAuthUser("전산팀",user_id)){%>	
	
	var fm = document.form1;
	
	var rent_l_cd = '<%=cp_bean.getTitle()%>';
	
	<%				if(from_page.equals("/fms2/cooperation/cooperation_n2_sc.jsp")){%>	
	fm.rent_l_cd.value = rent_l_cd.substr(10,13);
	<%				}%>
	
	<%				if(title_gubun.equals("소액채권대손처리요청")){%>
	fm.rent_l_cd.value = rent_l_cd.substr(12,13);
	<%				}%>

	<%			}%>	
	<%		}%>		
	<%	}%>			
//-->
</script>		
</body>
</html>
			    