<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" 	scope="page"/>


<%
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
		
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String mail_code	= request.getParameter("mail_code")==null?"":request.getParameter("mail_code");
	
	String answer1	 	= request.getParameter("answer1")==null?"":request.getParameter("answer1");
	String answer2	 	= request.getParameter("answer2")==null?"":request.getParameter("answer2");
	String answer3	 	= request.getParameter("answer3")==null?"":request.getParameter("answer3");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//연장대여정보
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
		
	//연장담당자
	UsersBean bus_user_bean = umd.getUsersBean(ext_fee.getExt_agnt());
	
	//이메일첨부파일
	Vector vt =  ImEmailDb.getImDmailEncListF("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc");
	int vt_size = vt.size();
	
	Hashtable ht1 = new Hashtable();
	Hashtable ht2 = new Hashtable();
	
	if(vt_size==0){
		vt =  ImEmailDb.getImDmailEncList("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc");
		vt_size = vt.size();
	}
	
	for(int i = 0 ; i < vt_size ; i++){
		if(i==0) ht1 = (Hashtable)vt.elementAt(i);
		if(i==1) ht2 = (Hashtable)vt.elementAt(i);
	}	
	
	//답변 체크	
	Hashtable ht3 = ImEmailDb.getImDmailInfo("5", rent_l_cd+""+rent_st, mail_code+"newcar_doc_re");
	int vt_size2 = 0;
	
	if(String.valueOf(ht3.get("GUBUN2")).equals(mail_code+"newcar_doc_re")) vt_size2 = 1;
			
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>연장계약 답변메일 보내기</title>
<style type="text/css">
<!--
.style1 {color: #88b228}
.style2 {color: #747474}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
-->
</style>
<script>
<!--
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') send_mail();
	}

	//메일수신하기
	function send_mail(){
		var fm = document.form1;	
	
			
		if(fm.answer1[0].checked == false && fm.answer1[1].checked == false){ alert("1번 답변이 선택되지 않았습니다."); return; }
		if(fm.answer2[0].checked == false && fm.answer2[1].checked == false){ alert("2번 답변이 선택되지 않았습니다."); return; }
		if(fm.answer3[0].checked == false && fm.answer3[1].checked == false){ alert("3번 답변이 선택되지 않았습니다."); return; }
		
		if(fm.answer1[0].checked == false)	{ alert("연장계약서 내용을 충분히 읽어보시고 1번 [ ○ 예 ] 에 체크해 주셔야 합니다."); return; }
		if(fm.answer2[0].checked == false)	{ alert("2번 답변에 반드시 [ ○ 예 ] 에 체크해 주셔야 합니다."); return; }
		if(fm.answer3[0].checked == false)	{ alert("3번 답변에 반드시 [ ○ 예 ] 에 체크해 주셔야 합니다."); return; }
		
		fm.action = "/fms2/lc_rent/mail_send_re.jsp";
		//fm.target = "_self";
		fm.target = "i_no";
		fm.submit();		
	}
	
	function openPopP(type,content_code,seq,filesize){
			
		var isImage = type.indexOf("image/") != -1 ? true : false;
		var isPDF = type.indexOf("/pdf") != -1 ? true : false;
		var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
		if( isImage || isPDF ){
			if(type.indexOf("image/") != -1 ) {
				url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print_email.jsp';
			}
								
			url = url + "?CONTENT_CODE="+content_code+"&SEQ=" + seq + "&S_GUBUN=" + filesize;
			var popName = "view_file";
			var aTagObj = document.getElementById("link_view_a");
				
			if( aTagObj == null ){
				var aTag = document.createElement("a");
				aTag.setAttribute("href", url);
				aTag.setAttribute("target",popName);
				aTag.setAttribute("id","link_view_a");
				target = document.getElementsByTagName("body");
				target[0].appendChild(aTag);
				aTagObj = document.getElementById("link_view_a");
			}else{
				aTagObj.setAttribute("href", url);
			}
				
			var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");
			
			aTagObj.click();
				
				
		}else{
			alert('보기를 할수없는 파일입니다.');
		} 	
	}				
//-->
</script>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
</head>
<body topmargin=0 leftmargin=0 bgcolor=#eef0dc>
<form name="form1" method="post" action="">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="mail_code" value="<%=mail_code%>">
<input type="hidden" name="content_st" value="newcar_doc">

<br><br><br><br>
<table width=675 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_img2.gif align=center>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_img1.gif height=220 align=center>
        	<table width=500 border=0 cellspacing=0 cellpadding=0>
        		<tr>
        			<td height=140></td>
        		</tr>
        		<tr>
        			<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow.gif align=absmiddle> <span class=style1><b> <%=client.getFirm_nm()%>  님</b></span></td>
        		</tr>
        	</table>
        </td>
    </tr>
    <tr>
    	<td height=20></td>
    </tr>
	<tr>
		<td align=center>
			<table width=530 border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td>아래 내용대로 진행할 의사가 있으시면 각 ○ 에 클릭해 주신 후 아래 답변 보내기 버튼을 클릭해 주십시오.</td>
				</tr>
				<tr>
					<td height=30></td>
				</tr>
				<tr>
					<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>1. 첨부한 jpg파일의 연장계약서 내용을 충분히 잘 읽어보았습니까?</span></td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer1" value='Y' <%if(answer1.equals("Y")){%>checked<%}%>> 예, 잘 읽어보았습니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type='radio' name="answer1" value='N' <%if(answer1.equals("N")){%>checked<%}%>> 아니오 </td>
				</tr>
				<tr>
					<td height=30></td>
				</tr>
				<tr>
					<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>2. 본 연장계약서 내용대로 연장계약을 진행할 의사가 있습니까?</span></td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer2" value='Y' <%if(answer2.equals("Y")){%>checked<%}%>> 예, 진행할 의사가 있습니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer2" value='N' <%if(answer2.equals("N")){%>checked<%}%>> 아니오 </td>
				</tr>
				<tr>
					<td height=30></td>
				</tr>
				<tr>
					<td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class=style6>3. 지금 보내는 e-mail을 아마존카 영업담당자가 받으면 연장계약이 성립하는 것에<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;동의합니까?</span></td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer3" value='Y' <%if(answer3.equals("Y")){%>checked<%}%>> 예, 동의합니다  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name="answer3" value='N' <%if(answer3.equals("N")){%>checked<%}%>> 아니오 </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height=15></td>
    </tr>
	<tr>
		<td align=center height=30><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_img4.gif></td>
	</tr>
	<tr>
		<td align=center>
			<table width=500 border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow_1.gif align=absmiddle> <b>계약서 :</b> 					
					<%if(String.valueOf(ht1.get("ATTACH_SEQ")).equals("")){%>
					<a href=<%=ht1.get("FILE_CONTENT")%> target=blank><%=ht1.get("FILEINFO")%></a>
					<%}else{%>
					<a href="javascript:openPopP('image/','<%=ht1.get("CONTENT_CODE")%>', '<%=ht1.get("ATTACH_SEQ")%>','<%=ht1.get("FILE_SIZE")%>');" title='보기' ><%=ht1.get("FILEINFO")%><%=ht1.get("FILENAME")%></a>
					<%}%>
					<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<%if(String.valueOf(ht2.get("ATTACH_SEQ")).equals("")){%>
					<a href=<%=ht2.get("FILE_CONTENT")%> target=blank><%=ht2.get("FILEINFO")%></a>
					<%}else{%>
					<a href="javascript:openPopP('image/','<%=ht2.get("CONTENT_CODE")%>', '<%=ht2.get("ATTACH_SEQ")%>','<%=ht2.get("FILE_SIZE")%>');" title='보기' ><%=ht2.get("FILEINFO")%><%=ht2.get("FILENAME")%></a>
					<%}%>
					</td>
				</tr>
				<tr>
					<td height=10></td>
				</tr>
				<tr>
					<td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_arrow_1.gif align=absmiddle> <b>영업담당 : <%=bus_user_bean.getUser_nm()%></b> <%=bus_user_bean.getUser_m_tel()%></td>
				</tr>
			</table>
		</td>
	</tr>
    <%if(vt_size2==0){%>
	<tr>
    	<td height=30></td>
    </tr>    
	<tr>
		<td align=center><a href="javascript:send_mail();"><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_button.gif align=absmiddle border=0></a></td>
	</tr>
    <%}else{%>
	<tr>
    	<td height=30></td>
    </tr>    
	<tr>
		<td align=center>* 이미 답변하였습니다.</td>
	</tr>
    <%}%>
	<tr>
    	<td height=15></td>
    </tr>
	
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/renew_pop_img3.gif></td>
    </tr>
</table>
<br><br><br><br>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>

</body>
</html>