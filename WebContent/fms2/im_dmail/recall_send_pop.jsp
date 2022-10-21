<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String param 	= request.getParameter("param")==null?"":request.getParameter("param");
	int cnt			= request.getParameter("cnt")==null?0:Integer.parseInt(String.valueOf(request.getParameter("cnt")));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddClientDatabase acl_db = AddClientDatabase.getInstance();
	
	String content_code  = "RECALL";
	String content_seq   = "RECALL";	
	String param_arr[]	 = null;
	
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	if(!param.equals("")){	param_arr = param.split(",");	}
	
	//파일등록을 위한 SEQ생성
	String i_seq = "";
	String i_seq_str = "";
	int i_seq_int = 0;
	Calendar calendar = new GregorianCalendar(Locale.KOREA);
	if(attach_vt_size > 0){
		for(int i = 0 ; i < attach_vt_size ; i++){
			Hashtable ht = (Hashtable)attach_vt.elementAt(i);
			if(i==attach_vt_size-1){
				if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("")){
					i_seq_int = Integer.parseInt(String.valueOf(ht.get("CONTENT_SEQ")).substring(10,12))+1;
					if(i_seq_int <10){	i_seq_str = "0"+String.valueOf(i_seq_int);	}else{	i_seq_str = String.valueOf(i_seq_int);	}
					if(String.valueOf(calendar.get(Calendar.YEAR)).equals(String.valueOf(ht.get("CONTENT_SEQ")).substring(6,10))){
						i_seq = String.valueOf(calendar.get(Calendar.YEAR)) + i_seq_str;
					}else{
						i_seq = String.valueOf(calendar.get(Calendar.YEAR)) + "01";
					}
				}
			}
		}
	}else{
		i_seq = String.valueOf(calendar.get(Calendar.YEAR)) + "01";
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">

//안내문파일등록
function save(){
	fm = document.form1;
	if(fm.file.value == ""){	alert("파일을 선택해 주세요!");		fm.file.focus();	return;		}		
		
    var str_dotlocation,str_ext,str_low, str_value;
    str_value  = fm.file.value;
  
    str_low   = str_value.toLowerCase(str_value);
    str_dotlocation = str_low.lastIndexOf(".");
    str_ext   = str_low.substring(str_dotlocation+1);

 //   if  ( str_ext == 'gif'  ||  str_ext == 'jpg' ) {
  //  } else {
//	      alert("gif 또는 jpg만 등록됩니다." );
//	      return false; 
 //   }
	
	if(!confirm("해당 파일을 등록하시겠습니까?")){	return;		}
	else{
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.SERVICE%>";
		fm.target = "RECALL_SAVE"
		window.open("", "RECALL_SAVE", "left=10, top=10, width=500, height=200, scrollbars=yes, status=yes, resizable=yes");
		fm.submit();
		
		setTimeout(function() {	location.reload();	}, 500);
	}
	
}

//안내문 메일발송
function ImEmail_Reg(mode){
	var fm = document.form1;
	var sel_recall = $("input[name='sel_recall']:checked").val();
	var mail_title = $("#mail_title").val();
	var mail_st = $("input[name='mail_st']:checked").val();
	if(mail_title==''){		alert("리콜안내문 기본멘트(이메일제목)를 입력해주세요. ");		return;		}
	if(mode=='test' && fm.test_mail.value==""){	alert("메일발송 테스트할 이메일을 입력해주세요.");	return;	}
	if(confirm('메일 발송 하시겠습니까?')){
		<%-- fm.action = "recall_send_mail_a.jsp?param=<%=param%>&content_seq="+sel_recall; --%>
		window.open("recall_send_mail_a.jsp?param=<%=param%>&content_seq="+sel_recall+"&mail_title="+mail_title+"&mode="+mode+"&test_mail="+fm.test_mail.value+"&mail_st="+mail_st, "VIEW_CLIENT", "left=20, top=20, width=650, height=300, scrollbars=yes");
		/* fm.submit(); */					
	}	
}


</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body>
<form action="" name="form1" method="POST" enctype="multipart/form-data">

<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='param' value='<%=param%>'>

<table width=100% border=0 cellpadding=0 cellspacing=0>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;FMS운영관리 > SMS 및 이메일 > <span class=style1><span class=style5>리콜안내문메일 등록/발송 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>리콜안내문 관리</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width="20%">안내문 등록</td>
                    <td width="*">&nbsp;&nbsp;
                    	<input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='RECALL<%=i_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.RECALL%>'>
                    </td>
                    <td align="center" width="20%">	
                    	<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
                    </td>
                </tr>
<%if(attach_vt_size > 0){
	for(int j = 0 ; j < attach_vt_size ; j++){
		Hashtable ht = (Hashtable)attach_vt.elementAt(j);
		
		if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("")){	%>			
                <tr>
   			<%if(j==0){%>
                    <td class='title' rowspan='<%=attach_vt_size %>'>안내문 선택</td>
       		<%} %>
                    <td>&nbsp;&nbsp;
         				<input type="radio" name="sel_recall" value="<%=ht.get("CONTENT_SEQ")%>" <%if(j==attach_vt_size-1){%>checked<%} %>>
         				<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME") %></a>
         			</td>
         			<td align="center">	 		
                    	<a href="javascript:window.open('https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>', 'DEL_FILE', 'left=10, top=10, width=550, height=250, scrollbars=yes, status=yes, resizable=yes');" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>
<%		}
	}
  }%>             
            </table>
        </td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr>
    <tr>
    	<td colspan="2" class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		    	<tr>
		    		<td class="title" width="20%">안내문 기본멘트(이메일제목)</td>
		    		<td width="*">&nbsp;&nbsp;&nbsp;
		    			<input type="text" name="mail_title" id="mail_title" size="70">
		    		</td>
		    	</tr>
    		</table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>안내문 발송 리스트</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>	
    <tr>
        <td colspan="2" class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='7%' class='title'>연번</td>
                    <td width='*'  class='title'>상호</td>
                    <td width='30%' class='title'>EMAIL</td>
                </tr>
                <%if(!param.equals("")){ 
                	for(int i=0; i<param_arr.length;i++){
                		Hashtable ht = acl_db.getClientOne(param_arr[i]);
                %>
                <tr>
                	<td align="center"><%=i+1%></td>
                	<td align="center"><%=ht.get("FIRM_NM")%></td>
                	<td align="center"><%=ht.get("CON_AGNT_EMAIL")%></td>
               	</tr>
                <%	}
                  }else{%>
                <tr>
                   <td colspan="3" align="center">선택된 고객이 없습니다.</td> 
                </tr>
                <%} %>
            </table>
         </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>안내문 구분</span></td>
        <td align="right"></td>
    </tr>
    <tr>
        <td colspan="2">
        	<input type="radio" id="recall_email" name="mail_st" value="1" onchange="" checked>
       		<label for="recall_email">리콜 안내문</label>
       		<input type="radio" id="service_email" name="mail_st" value="2" onchange="">
       		<label for="service_email">캠페인 안내문</label>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
        <td align="right" colspan="2">
        	<input type="text"  name="test_mail" value="" size=15>
        	<a href="javascript:ImEmail_Reg('test');">[테스트메일발송]</a>        	
        <%if(!param.equals("")){ %>
            <%if(!auth_rw.equals("1")){%>
            &nbsp;&nbsp;&nbsp;
            <a href="javascript:ImEmail_Reg('real');"><img src=/acar/images/center/button_bh.gif align=absmiddle border=0></a>&nbsp;
            <%}%>
        <%} %>    
		  <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
