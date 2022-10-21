<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.database.*, acar.alink.*, acar.util.*"%>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>

<%
	String doc_code = request.getParameter("doc_code")==null?"":request.getParameter("doc_code");
	String ssn = request.getParameter("ssn")==null?"":request.getParameter("ssn");
	
	String login_yn = "";
	
	//���ڹ��� ���� doc_code 
	Hashtable ht = ln_db.getALink("e_doc_mng", doc_code);
	String doc_name = ht.get("DOC_NAME")+"";
	String doc_url = ht.get("URL")+"";
	String doc_type = ht.get("DOC_TYPE")+"";	
	String client_id = ht.get("CLIENT_ID")+"";
	String rent_mng_id = ht.get("RENT_MNG_ID")+"";
	String rent_l_cd = ht.get("RENT_L_CD")+"";
	String term_dt = ht.get("TERM_DT")+"";
	String end_dt = ht.get("END_DT")+"";
	String end_file = ht.get("END_FILE")+"";
	String use_yn = ht.get("USE_YN")+"";
	String sign_key = ht.get("SIGN_KEY")+"";
	
	/*
	out.println("doc_code="+doc_code);
	out.println("client_id="+client_id);
	out.println("rent_mng_id="+rent_mng_id);
	out.println("rent_l_cd="+rent_l_cd);
	*/
	
	String r_term_dt = AddUtil.replace(term_dt,"-","");
	
	if(!r_term_dt.equals("") && !r_term_dt.equals("null")){
		r_term_dt = term_dt.substring(0,10);
		r_term_dt = AddUtil.replace(r_term_dt,"-","");
	}
	String today = AddUtil.getDate(4);
	
	if(!end_dt.equals("") && !end_file.equals("")){
		doc_url = end_file;
	}
	
	if(!ssn.equals("")){//�Է°��� �ִ�
		//��Ȯ��
		int result = ln_db.getLoginCustMail(client_id, rent_mng_id, rent_l_cd, ssn);
		
		if(result == 1){
			login_yn="r_ok";							
		}else if( result == 2){
			login_yn="db_error";
		}else{
			login_yn="no_id";
		}
		
		//����������,�°�������-�������/����ڹ�ȣ�� ���
		if(!login_yn.equals("r_ok") && !sign_key.equals("") && !sign_key.equals("null") && !sign_key.equals("NULL")){
			String enp_no = AddUtil.replace(ssn, "-", ""); 
			if(enp_no.equals(sign_key)){
				login_yn="r_ok";		
			}
		}
		
	}else{
		if(doc_name.equals("�ε��μ���") || doc_name.equals("(�ɻ��)����(�ſ�)���� ����_�̿�_��ȸ���Ǽ�")){ //�ε��μ���/����������ȸ���Ǽ��� ���������� �ٷ� ó��
			login_yn="q_ok";
		}else{
			login_yn="no";
		}	
	}
	
%>
<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<title>����Ȯ�ηα���</title>
</head>
<SCRIPT LANGUAGE="JavaScript">
<!--
function OpenAmazonCAR(arg){
	if(arg=='1'){
	   	var fm = document.form1;
	   	fm.action = fm.doc_url.value;
	   	fm.submit();
	}else if(arg=='2'){
		alert('error');
		return;
	}	
}

function EnterDown(){
	var keyValue = event.keyCode;
	if (keyValue =='13') submitgo();
}

function submitgo(){
   	var fm = document.form1;
   	<%if(!end_dt.equals("") && !end_file.equals("")){%>
   	<%}else{%>
   	if(fm.confirm.checked == false){   		alert("�̿��� �� ��������ó����ħ�� �����Ͻʽÿ�.");   return;   	}
   	<%}%>
	if(fm.ssn.value=="")	{   	alert("�����/��������� �Է��Ͻʽÿ�.");   fm.ssn.focus();   		return;	}
	fm.action = 'index.jsp';
   	fm.submit();
}
//-->
</SCRIPT>

<BODY bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" 
<%	if(login_yn.equals("ok")){%>
	onLoad="javascript:submitgo();"
<%	}else if(login_yn.equals("r_ok")){%>
	onLoad="javascript:OpenAmazonCAR('1');"
<%	}else if(login_yn.equals("db_error")){%>
	onLoad="javascript:OpenAmazonCAR('2');"
<%	}else{%>
	onLoad="javascript:document.form1.ssn.focus();"
<%	}%>
>
<form name="form1" action="index.jsp" method="post">
<input type="hidden" name="doc_code" value="<%= doc_code %>">
<input type="hidden" name="doc_url" value="<%= doc_url %>">
<input type="hidden" name="doc_type" value="<%= doc_type %>">

<div style="width: 480px; height:50px; margin: 0 auto;">
&nbsp;
</div>

<%if(use_yn.equals("N")){%>
<input type="hidden" name="ssn" value="">
<div style="width: 480px; margin: 0 auto;">
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					<span style="height:10px;">&nbsp;<br>
					<span style="font-size:20px;">���� �����Դϴ�.</span><br><br>
					<span style="font-size:20px;">��߼۵� ��� ��߼۵� URL�� Ŭ�����ּ���.</span><br><br>
					<span style="font-size:20px;">�����մϴ�.</span><br>
					<span style="height:10px;">&nbsp;
				</div>
			</div>
</div>
<%}else{%>
<%	if(end_dt.equals("")){ 
		//��ȿ�Ⱓ Ȯ��
		if(AddUtil.parseInt(r_term_dt) >= AddUtil.parseInt(today)){	
%>
<div style="width: 480px; margin: 0 auto;">
			<div style="padding: 20px 20px;">
				<span style="font-size:20px;">Ȯ�����ּ���.</span>
			</div>
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">				
					1. ���� ���� ���� �� üũ�� ������ ������ �����մϴ�.<br>
					2. ���� �� üũ�� ���� �߻��ϴ� ���� ȿ�¿� �����մϴ�.<br>
					3. �̸��� Ȥ�� SMS�� �߼۵Ǵ� ������ ���뿡 �����մϴ�.<br>
					4. ���� �� üũ�� ���� ������ ���ο��� ������ �����մϴ�.<br><br> 
					<input type="checkbox" name="confirm" value="Y">
					<a href="guide.jsp" target='_blank' >�̿���</a> �� <a href="private.jsp" target='_blank' >��������ó����ħ</a>�� �����մϴ�.
				</div>
			</div>
</div>	

<div id="template_a">
<table width=435 border=0 cellspacing=0 cellpadding=0 align=center>	
     <tr>
        <td height=40></td>
     </tr>
     
     <tr>
        <td>
            <table width=435 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/edoc_fms/acar/images/edoc_fms/bar_num.gif width=435 height=41></td>
                </tr>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td>
                        <table width=435 border=0 cellpadding=0 cellspacing=0 background=/edoc_fms/acar/images/edoc_fms/login_bg.gif>
                            <tr>
                                <td colspan=4><img src=/edoc_fms/acar/images/edoc_fms/login_up.gif width=436 height=6></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=135 align=center><img src=/edoc_fms/acar/images/edoc_fms/login_img1.gif width=94 height=86></td>
                                <td width=22><img src=/edoc_fms/acar/images/edoc_fms/vline.gif width=1 height=67></td>
                                <td width=182>
                                    <input type="text" name="ssn" value="<%=ssn%>" size=18 class=text onKeydown="EnterDown()" tabindex=1>
                                </td>
                                <td width=97><a href="javascript:submitgo()"><img src=/edoc_fms/acar/images/edoc_fms/button_confirm.gif width=75 height=54></a></td>
                            </tr>
                            <tr align=center>
                                <td height=40 colspan=4><img src=/edoc_fms/acar/images/edoc_fms/ment.gif width=393 height=11> </td>
                            </tr>
                            <tr>
                                <td colspan=4 height=10></td>
                            </tr>
                            <tr>
                                <td colspan=4><img src=/edoc_fms/acar/images/edoc_fms/login_dw.gif width=436 height=6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>	
<%		}else{%>
<input type="hidden" name="ssn" value="">
<div style="width: 480px; margin: 0 auto;">
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					<span style="height:10px;">&nbsp;<br>
					<span style="font-size:20px;">����� URL�Դϴ�.</span><br><br>
					<span style="font-size:20px;">�ۼ��Ⱓ�� �������ϴ�.</span><br><br>
					<span style="font-size:20px;">��߼� ��û�Ͻʽÿ�.</span><br><br>
					<span style="font-size:20px;">�����մϴ�.</span><br>
					<span style="height:10px;">&nbsp;
				</div>
			</div>
</div>
<%		}%>    
<%	}else{%>
<div style="width: 480px; margin: 0 auto;">
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 12px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px 10px 10px 30px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px; text-align: left;">
					<span style="height:10px;">&nbsp;<br>
					<span style="font-size:20px;">�Ϸ�� �����Դϴ�.</span><br><br>
					<span style="font-size:20px;">�������� Ȯ�ΰ����մϴ�.</span><br><br>
					<span style="font-size:20px;">�����մϴ�.</span><br>
					<span style="height:10px;">&nbsp;
				</div>
			</div>
</div>	
<div id="template_a">
<table width=435 border=0 cellspacing=0 cellpadding=0 align=center>	
     <tr>
        <td height=40></td>
     </tr>
     
     <tr>
        <td>
            <table width=435 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=/edoc_fms/acar/images/edoc_fms/bar_num.gif width=435 height=41></td>
                </tr>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td>
                        <table width=435 border=0 cellpadding=0 cellspacing=0 background=/edoc_fms/acar/images/edoc_fms/login_bg.gif>
                            <tr>
                                <td colspan=4><img src=/edoc_fms/acar/images/edoc_fms/login_up.gif width=436 height=6></td>
                            </tr>
                            <tr>
                                <td colspan=4>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=135 align=center><img src=/edoc_fms/acar/images/edoc_fms/login_img1.gif width=94 height=86></td>
                                <td width=22><img src=/edoc_fms/acar/images/edoc_fms/vline.gif width=1 height=67></td>
                                <td width=182>
                                    <input type="text" name="ssn" value="<%=ssn%>" size=18 class=text onKeydown="EnterDown()" tabindex=1>
                                </td>
                                <td width=97><a href="javascript:submitgo()"><img src=/edoc_fms/acar/images/edoc_fms/button_confirm.gif width=75 height=54></a></td>
                            </tr>
                            <tr align=center>
                                <td height=40 colspan=4><img src=/edoc_fms/acar/images/edoc_fms/ment.gif width=393 height=11> </td>
                            </tr>
                            <tr>
                                <td colspan=4 height=10></td>
                            </tr>
                            <tr>
                                <td colspan=4><img src=/edoc_fms/acar/images/edoc_fms/login_dw.gif width=436 height=6></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>
<%	}%>
<%}%>
<div style="width: 480px; height:10px; margin: 0 auto;">
&nbsp;
</div>
<table width=435 border=0 cellspacing=0 cellpadding=0 align=center>	
     <tr>
        <td align=center><img class="w-100 display-block my-3" src="https://www.amazoncar.co.kr/resources/images/logo_1.png" alt="�Ƹ���ī"/></td>
     </tr>
</table>     
</form>		
<SCRIPT LANGUAGE="JavaScript">
<!--
<%	if(login_yn.equals("q_ok")){%>
	OpenAmazonCAR('1');
<%	}%>
//-->
</SCRIPT>
</body>
</html>

