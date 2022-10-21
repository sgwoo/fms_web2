<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="area_bean" class="acar.user_mng.AreaBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String filename2 = "";
	String user_aut2 = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String out_dt = "";
	String taste = "";
	String special ="";
	String gundea = "";
	String area_id = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 		= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_i_tel 	= user_bean.getUser_i_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	filename2 	= user_bean.getFilename2();
	user_work 	= user_bean.getUser_work();
	in_tel		= user_bean.getIn_tel();
	hot_tel		= user_bean.getHot_tel();
	out_dt		= user_bean.getOut_dt();
	taste		= user_bean.getTaste();
	special		= user_bean.getSpecial();
	gundea		= user_bean.getGundea();
	area_id		= user_bean.getArea_id();
	
	
	//부서리스트 조회
	DeptBean dept_r [] = umd.getDeptAll();
	//지점리스트 조회
	BranchBean br_r [] = umd.getBranchAll();
	//근무지리스트 조회
	AreaBean area_r [] = umd.getAreaAll("");
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();	
	
	// * Algorithm AES Encrypt
        //   String message = "1234";
       //    String encSsn = EncryptionUtils.encryptAES(message);
       //   * 
        //  * Algorithm AES Decrypt
        //  * String message = "";
        //  * String encSsn = EncryptionUtils.decryptAES(message); 

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "USERS";
	String content_seq  = user_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	String file1_yn = "";
	String file2_yn = "";
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//비밀번호 변경
	function ChangePwd(){
		window.open("/fms2/menu/pass_u.jsp?user_id=<%=user_id%>&from_page=info_u.jsp", "PASS", "left=200, top=100, width=400, height=200, scrollbars=yes, status=yes, resizable=yes");
	}
	//등록
	function UserAdd(){
		var theForm = document.form1;
		if(!CheckField()){ return; }
		theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;		
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
		if(!confirm('등록하시겠습니까?')){ return; }
		theForm.cmd.value= "i";
		theForm.target="i_no";
		theForm.submit();
	}
	//수정
	function UserUp(){
		var theForm = document.form1;
		if(!CheckField()){ return; }
		theForm.user_ssn.value = theForm.user_ssn1.value + "" + theForm.user_ssn2.value;	
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
		
		if(theForm.t_zip.value=="")		{		alert("주민등록주소 우편번호를 입력하하세요!!.");		theForm.t_zip.focus();			return false;	}
		if(theForm.t_zip.value.length>5)	{	alert("우편번호는 5자리를 넘을 수 없습니다.\n\n 5자리 이상일경우 관리자에게 문의주세요.");			theForm.t_zip.focus();		return false;	}	
		
		if(!confirm('수정하시겠습니까?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}
	
	//퇴사
	function UserDel(){
		var theForm = document.form1;
		if(!confirm('퇴사처리 하시겠습니까?')){ return; }
		if(!confirm('정말 퇴사처리 하시겠습니까?')){ return; }		
		if(!confirm('진짜 정말 퇴사처리 하시겠습니까?')){ return; }				
		theForm.cmd.value= "d";
		theForm.target="i_no";
		theForm.submit();
	}
	//입력항목 점검
	function CheckField(){
		var theForm = document.form1;	
		if(theForm.br_id.value=="")		{		alert("지점을 선택하십시요.");					theForm.br_id.focus();			return false;	}
		if(theForm.dept_id.value=="")		{		alert("부서를 선택하십시요.");					theForm.dept_id.focus();		return false;	}
		if(theForm.user_nm.value=="")		{		alert("이름을 입력하십시요.");					theFrom.user_nm.focus();		return false;	}
		if(theForm.user_ssn1.value=="")		{		alert("주민등록번호를 입력하십시요.");				theFrom.user_ssn1.focus();		return false;	}
		if(theForm.user_ssn2.value=="")		{		alert("주민등록번호를 입력하십시요.");				theFrom.user_ssn2.focus();		return false;	}
		if(theForm.id.value=="")		{		alert("ID를 입력하십시요.");					theFrom.id.focus();			return false;	}
		if(theForm.user_psd.value=="")		{		alert("비밀번호를 입력하십시요.");				theFrom.user_psd.focus();		return false;	}
		if(theForm.user_psd.value.length<6)	{		alert("비밀번호는 6자리 이상이여야 합니다.");			theForm.user_psd.focus();		return false;	}	
		if(theForm.in_tel.value.length>5)	{		alert("내선번호는 5자리를 넘을 수 없습니다.\n\n 5자리 이상일경우 관리자에게 문의주세요.");			theForm.in_tel.focus();		return false;	}	
		<%//if(dept_id.equals("0002")){%>
	//	if(theForm.area_id.value ==""){	alert("근무지를 입력하십시요.");		theFrom.area_id.focus();		return false;	}
		<%//}%>
		return true;
	}
	
	function CheckPWDField()
{
	var theForm = document.UserForm;
	
	var paramObj = theForm.user_psd_a.value;
	
	var chk_eng = paramObj.search(/[a-zA-Z]/ig);
	var chk_num = paramObj.search(/[0-9]/g);
	var chk_spe = paramObj.search(/[~!@\#$%<>^&*\()\-=+_\']/ig);
	
	if(theForm.user_psd_b.value=="")
	{
		alert("변경전 비밀번호를 입력하십시요.");
		theForm.user_psd_b.focus();
		return false;
	}
	if(theForm.user_psd_a.value=="")
	{
		alert("변경후 비밀번호를 입력하십시요.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_b.value==theForm.user_psd_a.value)
	{
		alert("변경전,후 비밀번호가 동일합니다.");
		theForm.user_psd_a.focus();
		return false;
	}
	if(theForm.user_psd_a.value.length<6)
	{
		alert("비밀번호는 6자리 이상이여야 합니다.");	
		theForm.user_psd_a.focus();
		return false;
	}
	if((chk_eng < 0 && chk_num < 0) || (chk_eng < 0 && chk_spe < 0) || (chk_spe < 0 && chk_num < 0))
	{
		alert("비밀번호는 영문,숫자,특수문자 중\n2가지 이상의 조합이어야 합니다.");	
		theForm.user_psd_a.focus();
		return false;
	}
	
	return true;
}
	
	//아이디중복체크
	function CheckUserID(){
		var theForm = document.form1;
		var theForm1 = document.UserIDCheckForm;
		theForm1.user_id.value=theForm.id.value;
		theForm1.cmd.value="ud";
		theForm1.target = "i_no";
		theForm1.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') CheckUserID();
	}	
	
	//사진올리기페이지 팝업
	function photo(st){
		var SUBWIN="./info_photo.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&file_st="+st;	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}
	
	function set_o_addr() //주소 상동체크
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.h_zip.value = fm.t_zip.value;
			fm.h_addr.value = fm.t_addr.value;
		}
		else
		{
			fm.h_zip.value = '';
			fm.h_addr.value = '';
		}
	}	
//-->
</script>
<script language="javascript">
		// 최소길이 & 최대길이 제한
		var minimum = 6;
		var maximun = 12;

		function chkPw(obj, viewObj) {
			var paramVal = obj.value;	

			var msg = chkPwLength(obj);

			if(msg == "") msg = "안전한 비밀번호 입니다.";

			document.getElementById(viewObj).innerHTML=msg;
		}

		// 글자 갯수 제한
		function chkPwLength(paramObj) {
			var msg = "";
			var paramCnt = paramObj.value.length;

			if(paramCnt < minimum) {
				msg = "최소 암호 글자수는 <b>" + minimum + "</b> 입니다.";
			} else if(paramCnt > maximun) {
				msg = "최대 암호 글자수는 <b>" + maximun + "</b> 입니다.";
			} else {
				msg = chkPwNumber(paramObj);
			}

			return msg;
		}

		// 암호 유용성 검사
		function chkPwNumber(paramObj) {
			var  msg = "";

			// 특수 문자 포함 이라면 주석을 바꿔 주시기 바랍니다.
			// if(!paramObj.value.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/))
			if(!paramObj.value.match(/([a-zA-Z0-9])|([a-zA-Z0-9])/)) {
				// msg = "비밀번호는 영어, 숫자, 특수문자의 조합으로 6~16자리로 입력해주세요.";
				msg = "비밀번호는 영어, 숫자의 조합으로 6~12자리로 입력해주세요.";
			} else {
				msg = chkPwContinuity(paramObj);
			}

			return msg;
		}

		// 암호 연속성 검사 및 동일 문자
		function chkPwContinuity(paramObj) {
			var msg = "";
			var SamePass_0 = 0; //동일문자 카운트
			var SamePass_1_str = 0; //연속성(+) 카운드(문자)
			var SamePass_2_str = 0; //연속성(-) 카운드(문자)
			var SamePass_1_num = 0; //연속성(+) 카운드(숫자)
			var SamePass_2_num = 0; //연속성(-) 카운드(숫자)

			var chr_pass_0;
			var chr_pass_1;
			var chr_pass_2;
			
			for(var i=0; i < paramObj.value.length; i++) {
				chr_pass_0 = paramObj.value.charAt(i);
				chr_pass_1 = paramObj.value.charAt(i+1);

				//동일문자 카운트
				if(chr_pass_0 == chr_pass_1)
				{
					SamePass_0 = SamePass_0 + 1
				}


				chr_pass_2 = paramObj.value.charAt(i+2);
				
				if(chr_pass_0.charCodeAt(0) >= 48 && chr_pass_0.charCodeAt(0) <= 57) {
					//숫자
					//연속성(+) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_num = SamePass_1_num + 1
					}
					
					//연속성(-) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_num = SamePass_2_num + 1
					}
				} else {
					//문자
					//연속성(+) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == 1)
					{
						SamePass_1_str = SamePass_1_str + 1
					}
					
					//연속성(-) 카운드
					if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1 && chr_pass_1.charCodeAt(0) - chr_pass_2.charCodeAt(0) == -1)
					{
						SamePass_2_str = SamePass_2_str + 1
					}
				}
			}
			
			if(SamePass_0 > 1) {
				msg = "동일숫자 및 문자를 3번 이상 사용하면 비밀번호가 안전하지 못합니다.(ex : aaa, bbb, 111)";
			}

			if(SamePass_1_str > 1 || SamePass_2_str > 1 || SamePass_1_num > 1 || SamePass_2_num > 1)
			{
				msg = "연속된 문자열(123 또는 321, abc, cba 등)을\n 3자 이상 사용 할 수 없습니다.";
			}

			return msg;
		}	
		
		
		
		
		
		
		
		
		</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body  onLoad="self.focus()">
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="filename" value="<%=filename%>">
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 사용자관리 > <span class=style5>사용자등록</span></span></td>
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
            <table border="0" cellspacing="1" width=450>
                <tr>			    	
                    <td class=title width=95>지점</td>			    	
                    <td width=130>&nbsp;<select name="br_id">
            			  <option value="">선택</option>
        <%    				for(int i=0; i<br_r.length; i++){
                				br_bean = br_r[i];%>
           				  <option value="<%= br_bean.getBr_id() %>"><%= br_bean.getBr_nm() %></option>
        <%					}%>
        				</select>
        				<script language="javascript">
        					document.form1.br_id.value = '<%=br_id%>';
        				</script>
                    </td>			    	
                    <td class=title width=95>부서</td>			        
                    <td width=130>&nbsp;<select name="dept_id">
        			      <option value="">선택</option>
        <%    				for(int i=0; i<dept_r.length; i++){
                				dept_bean = dept_r[i];%>
           				  <option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
        <%					}%>								
        				</select>
        				<script language="javascript">
        					document.form1.dept_id.value = '<%=dept_id%>';
        				</script>
                    </td>
			    </tr>
                <tr>
        		    <td class=title>이름</td>
        	        <td>&nbsp;<input type="text" name="user_nm" value="<%=user_nm%>" size="15" class=text style='IME-MODE: active' <%if(dept_id.equals("1000")||dept_id.equals("8888")){%>readonly<%}%>></td>			    	
                    <td class=title>주민번호</td>
	    	        <td>&nbsp;<input type="text" name="user_ssn1" value="<%=user_ssn1%>" size="6" maxlength=6 class=text>-<input type="password" name="user_ssn2" value="<%=user_ssn2%>" size="7" maxlength=7 class=text></td>	    
           	    </tr>
           	    <tr>
		            <td class=title>ID</td>
		            <td colspan="3">&nbsp;<input type="text" name="id" value="<%=id%>" size="15" class=text onKeyDown='javascript:enter()' style='IME-MODE: inactive'></td>
				</tr>
				<tr>
		            <td class=title>비밀번호</td>
		            <td colspan="3">&nbsp;<input type="password" name="user_psd" value="<%=user_psd%>" size="16" class=whitetext onKeyUp="javascript:chkPw(this, 'chkPwView');" readonly>
					&nbsp;&nbsp;<span id="chkPwView"></span><!-- <br>&nbsp; ※비밀번호는 영어, 숫자의 조합으로 6~12자리로 입력해주세요.-->
					<input type="button" class="button" id="cng_pw" value='비밀번호변경' onclick="javascript:ChangePwd();">
					</td>
           	    </tr>
				<!--
           	    <tr>
                    <td class=title>운전면허</td>
			        <td>&nbsp;<input type="text" name="lic_no" value="<%=lic_no%>" size="15" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'></td>			    	
                    <td class=title>면허취득일</td>
			        <td>&nbsp;<input type="text" name="lic_dt" value="<%=lic_dt%>" size="16" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
           	    </tr>				
				-->
           	    <tr>
		            <td class=title>집전화</td>
		            <td>&nbsp;<input type="text" name="user_h_tel" value="<%=user_h_tel%>" size="15" class=text></td>
			        <td class=title>휴대폰</td>
			        <td>&nbsp;<input type="text" name="user_m_tel" value="<%=user_m_tel%>" size="16" class=text></td>
           	    </tr>
				<tr>
		            <td class=title>내선번호</td>
		            <td>&nbsp;<input type="text" name="in_tel" value="<%=in_tel%>" size="15" class=text></td>
			        <td class=title>사무실(직통)</td>
			        <td>&nbsp;<input type="text" name="hot_tel" value="<%=hot_tel%>" size="16" class=text></td>
           	    </tr>
				<!--
           	    <tr>
		            <td class=title>취미</td>
		            <td>&nbsp;<input type="text" name="taste" value="<%=taste%>" size="15" class=text></td>
			        <td class=title>특기</td>
			        <td>&nbsp;<input type="text" name="special" value="<%=special%>" size="16" class=text></td>
           	    </tr>
           	    <tr>
		            <td class=title>무선인터넷사용자번호</td>
		            <td>&nbsp;<input type="text" name="user_i_tel" value="<%=user_i_tel%>" size="15" class=text></td>
			        <td class=title>군필여부</td>
			        <td>&nbsp;<input type="text" name="gundea" value="<%=gundea%>" size="16" class=text></td>
           	    </tr>
				-->
           	    
				 <tr>
		            <td class=title>직위</td>
		            <td>&nbsp;<input type="text" name="user_pos" value="<%=user_pos%>" size="15" class=text style='IME-MODE: active'></td>
			        <td class=title>직책</td>
			        <td>&nbsp;<input type="text" name="" value="<%if(user_id.equals("000004")){%>총무팀장<%}else if(user_id.equals("000003")){%>임원<%}else if(user_id.equals("000005")){%>영업팀장<%}else if(user_id.equals("000026")){%>고객지원팀장<%}else if(user_id.equals("000237")){%>IT마케팅팀장<%}%><%//=user_pos%>" size="15" class=text style='IME-MODE: active'></td>
           	    </tr>
            	<tr>
			    	<td class=title>보안메일</td>
			    	<td>&nbsp;<input type="text" name="mail_id" value="<%=user_bean.getMail_id()%>" size="15" class=whitetext style="ime-mode:disabled">
                    </td>
			    	<td class=title>메일비번</td>
			    	<td>&nbsp;<%if(nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals(user_bean.getUser_id())){%><%=umd.getVoaMailPswd(user_bean.getMail_id())%><%}%></td>
            	</tr>
				<tr>
					<td class=title>입사일자</td>
			        <td>&nbsp;<input type="text" name="enter_dt" value="<%=enter_dt%>" size="15" class=text onBlur='javscript:this.value = ChangeDate(this.value);' readonly></td>
		            <td class=title>인터넷팩스<br>수신번호</td>
		            <td>&nbsp;<input type="text" name="i_fax" value="<%=user_bean.getI_fax()%>" size="15" class=text style="ime-mode:disabled"></td>
           	    </tr>
				    <%if(nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals(user_bean.getUser_id())){%>
            	<tr>
			    	<td class=title>인터넷팩스ID</td>
			    	<td>&nbsp;<input type="text" name="fax_id" value="<%=user_bean.getFax_id()%>" size="15" class=whitetext style="ime-mode:disabled">
                    </td>
			    	<td class=title>인터넷팩스PW</td>
			    	<td>&nbsp;<input type="text" name="fax_pw" value="<%=user_bean.getFax_pw()%>" size="15" ></td>
            	</tr>
				<%}%>
					<%	String email_1 = "";
						String email_2 = "";
						if(!user_email.equals("")){
							int mail_len = user_email.indexOf("@");
							if(mail_len > 0){
								email_1 = user_email.substring(0,mail_len);
								email_2 = user_email.substring(mail_len+1);
							}
						}
					%>													
           	    <tr>
			        <td class=title>이메일</td>
			        <td colspan=3>&nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='15' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
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
						        <input type='hidden' name='user_email' value='<%=user_email%>'>
								<!--<input type="text" name="user_email" value="<%=user_email%>" size="53" class=text>-->
								</td>
           	    </tr>
           	    <%if(dept_id.equals("1000")||dept_id.equals("8888")){%>
           	    <input type='hidden' name='loan_st' value='<%=user_bean.getLoan_st()%>'>
           	    <input type='hidden' name='partner_id' value='<%=user_bean.getPartner_id()%>'>
           	    <input type='hidden' name='add_per' value='<%=user_bean.getAdd_per()%>'>
           	    <input type='hidden' name='area_id' value='<%=area_id%>'>
           	    <%}else{%>
           	    <tr>
			        <td class=title>채권유형</td>
			        <td>&nbsp;
			            <select name="loan_st">
			        		<option value="">선택</option>
			    			<option value="1" <%if(user_bean.getLoan_st().equals("1"))%>selected<%%>>1군</option>
			    			<option value="2" <%if(user_bean.getLoan_st().equals("2"))%>selected<%%>>2군</option>
						</select>
			        </td>
			        <td class=title>채권파트너</td>
			        <td>&nbsp;
        			    <select name="partner_id">
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_bean.getPartner_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>
			        </td>
           	    </tr>	
           	    <tr>
		            <td class=title colspan=3>채권파트너가산율</td>
		            <td>&nbsp;<input type="text" name="add_per" class=text value="<%=user_bean.getAdd_per()%>" size="5" maxlength='5'>%
                    </td>
           	    </tr>
		
           	    <tr>
		            <td class=title>채권그룹</td>
		            <td colspan=3>&nbsp;<select name="area_id">
        			      <option value="">선택</option>
        <%    				for(int i=0; i<area_r.length; i++){
                				area_bean = area_r[i];%>
           				  <option value="<%= area_bean.getCode() %>"><%= area_bean.getNm() %></option>
        <%					}%>								
        				</select>
        				<script language="javascript">
        					document.form1.area_id.value = '<%=area_id%>';
        				</script>
		    	            
                    </td>
				</tr>
				<%}%>
		
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
								// 우편번호와 주소 정보를 해당 필드에 넣고, 커서를 상세주소 필드로 이동한다.
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>주민등록주소</td>
				  <td colspan=3>
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' readonly  value="<%=user_bean.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					<input type="text" name="t_addr" id="t_addr" size="50" value="<%=user_bean.getAddr()%>" style='IME-MODE: active'>

				  </td>
				</tr>
           	    
				<%//if(user_id.equals("000096")){%>
				<tr>
				  <td class=title>실거주지주소</td>
				  <script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('h_zip').value = data.zonecode;
								document.getElementById('h_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>	
				  <td colspan=3><input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>상동
					<input type="text" name="h_zip" id="h_zip" size="7" maxlength='7' readonly value="<%=user_bean.getHome_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					<input type="text" name="h_addr" id="h_addr" size="50" value="<%=user_bean.getHome_addr()%>" style='IME-MODE: active'>

				  </td>
				</tr>
				
				<%//}%>
           	    <tr>
		            <td class=title>담당업무</td>
		            <td colspan=3>&nbsp;<textarea name="user_work" cols="51" rows="3" class="text" style='IME-MODE: active'><%=user_work%></textarea></td>
           	    </tr>
           	    <tr>
		            <td class=title>FMS 고객<br>인사말</td>
		            <td colspan=3>&nbsp;<textarea name="content" cols="51" rows="5" class="text"><%=content%></textarea></td>
           	    </tr>
           	    <tr>
		            <td class=title>사진<br>(외부용-FMS조직도&고객FMS)</td>
                    <td colspan=3 align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"1")){
    									file1_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    							
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(file1_yn.equals("")){%>
    						<a href="javascript:photo('1');"><img src=../images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        			    
                    </td>
                </tr>
           	    <tr>
		            <td class=title>사진<br>(내부용-모바일FMS)</td>
                    <td colspan=3 align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"2")){
    									file2_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    														
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(file2_yn.equals("")){%>
    						<a href="javascript:photo('2');"><img src=../images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        	
                    </td>
                </tr>				
				<%if(!out_dt.equals("") || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>	
           	    <tr>
			        <td class=title>퇴사일자</td>
			        <td colspan=3>&nbsp;<input type="text" name="out_dt" value="<%=out_dt%>" size="11" class=text>
			    <%				if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>			  	
				        <a href="javascript:UserDel()"><img src=../images/center/button_out.gif border=0 align=absmiddle></a>
				<%				}%>					
					</td>
           	    </tr>				
				<%}%>
            </table>
        </td>
    </tr>   
    <tr>
        <td>
            <table border="0" cellspacing="2" width=450>
                <tr>
    			    <td align="right">
    <%				if(ck_acar_id.equals(user_id) || nm_db.getWorkAuthUser("관리자모드",ck_acar_id)){%>			  
    <%					if(user_id.equals("")){%>
    		        <a href="javascript:UserAdd()"><img src=../images/pop/button_reg.gif border=0></a>
    <%					}else{%>
    		        <a href="javascript:UserUp()"><img src=../images/pop/button_modify.gif border=0></a>
    <%					}%>
    <%				}%>    
     		        <a href="javascript:self.close();window.close();"><img src=../images/pop/button_close.gif border=0></a>
    			    </td>
			    </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<form action="/acar/user_mng/user_id_check_null.jsp" name="UserIDCheckForm" method="post">
<input type="hidden" name="user_id" value="">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="h_id" value="<%=id%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>