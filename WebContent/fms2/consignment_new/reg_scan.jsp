<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");	//����
	String cons_no 	= request.getParameter("cons_no")  ==null?"":request.getParameter("cons_no");  //Ź�۹�ȣ
	String gubun 	= request.getParameter("gubun")  ==null?"":request.getParameter("gubun");  //����	
	String file_st 	= request.getParameter("file_st")  ==null?"":request.getParameter("file_st");  //����
//jpg��
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/consignment/"+theURL;
		window.open(theURL,winName,features);
	}
	//����ϱ�
	function save(){
		fm = document.form1;
		if(fm.filename2.value == ""){	alert("�����񿵼����� JPG ��ĵ�� �� ����Ͻʽÿ�!");		fm.filename2.focus();	return;		}		
					
		//��ĵ���� Ȯ���ڰ� ".JPG" ��ġ üũ 
		var file = fm.filename2.value;
		file = file.slice(file.indexOf("\\") +1 );
		ext = file.slice(file.indexOf(".")).toLowerCase();
		
		if(ext != '.jpg'){
			alert('JPG�� �ƴմϴ�. JPG�� ��ĵ�� ���ϸ� ����� �����մϴ�.'); 	
			fm.filename2.focus(); 	
			return;
		}				
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/consignment_reg_scan_a.jsp";
//		fm.target = "i_no";
		fm.submit();
	}
	
	function file_save(){
		var fm = document.form1;	
				
		if(!confirm('���ϵ���Ͻðڽ��ϱ�?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.CONSIGNMENT%>";
		fm.submit();
	}

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="seq" 	value="<%=seq%>">
  <input type='hidden' name="cons_no"	value="<%=cons_no%>">
  <input type='hidden' name="gubun"	value="<%=gubun%>">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>������ û���ݾ�(����/����ī��)/������ ������ ��ĵ���</span></span></td>
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
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
              
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td >&nbsp;
        			<input type='file' name="file" size='40' class='text'>
					<%-- <input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=file_st%><%=cons_no%><%=seq%>' /> --%>
					<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=cons_no%><%=seq%>_<%=file_st%>' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.CONSIGNMENT%>' />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">
        <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a href='javascript:file_save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
        &nbsp;
        <%}%>
        <a href='javascript:window.close()'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
