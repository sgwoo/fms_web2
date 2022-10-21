<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String content_code = request.getParameter("content_code")==null?"":request.getParameter("content_code");
	String content_seq = request.getParameter("content_seq")==null?"":request.getParameter("content_seq");
	int seq = request.getParameter("seq")==null?0:AddUtil.parseDigit(request.getParameter("seq"));
		
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
	if(!content_code.equals("") && !content_seq.equals("")){
		//ACAR_ATTACH_FILE LIST
		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
		attach_vt_size = attach_vt.size();
	}		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var size = <%=attach_vt_size%>;
	var imgs = new Array();
	
	<%for(int i=0; i<attach_vt_size; i++){
		Hashtable ht = (Hashtable)attach_vt.elementAt(i);    %>		
	
		imgs[<%=i%>] = '<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>';
	
	<%}%>	
	

	function pass(cmd){	
	
		var img_idx = 0;
		
		if(cmd == 'b'){//이전
			if(document.form1.seq.value == '1'){
				alert('이전 사진은 없습니다.');		
			}else{
				img_idx = toInt(document.form1.seq.value)-2;
				document.carImg.src = 'https://fms3.amazoncar.co.kr'+imgs[img_idx];
				document.form1.seq[img_idx].selected = true;
			}
		}else{//다음
			if(document.form1.seq.value == size){
				alert('다음 사진은 없습니다.');		
			}else{				
				img_idx = toInt(document.form1.seq.value);
				document.carImg.src = 'https://fms3.amazoncar.co.kr'+imgs[img_idx];
				document.form1.seq[img_idx].selected = true;				
			}		
		}
	}	
	
	function move(){	
		var img_idx = 0;
		img_idx = toInt(document.form1.seq.value)-1;		
		document.carImg.src = 'https://fms3.amazoncar.co.kr'+imgs[img_idx];
	}		
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>

<table border=0 cellspacing=0 cellpadding=0 width=640>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=640>
                <tr> 
                    <td class=title>사진</td>
                </tr>
                <tr valign="top"> 
                    <td align="center"> 
        			<%if(attach_vt_size>0 && seq>0){%>
        			<%	for(int i=0; i<attach_vt_size; i++){
        					Hashtable ht = (Hashtable)attach_vt.elementAt(i);           					        					        					
        					if(AddUtil.parseDigit(String.valueOf(ht.get("SEQ"))) == seq){
        			%>        			        				
        				<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="640" height="480">
        	  		<%		}
        	  			}
        	  		%>
        	  				  
        		  	<%}else if(attach_vt_size>0 && seq==0){
        		  		Hashtable ht = (Hashtable)attach_vt.elementAt(0);
        		  	%>
        		  		<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="640" height="480">		  
        		  	<%}%>			
        	    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    <tr> 
        <td width="60"> 
            <select name="seq" onchange="javascript:move()">
                <%for(int i=0; i<attach_vt_size; i++){
			Hashtable ht = (Hashtable)attach_vt.elementAt(i);   				
	        %>		
                <option value="<%=i+1%>" <%if(AddUtil.parseDigit(String.valueOf(ht.get("SEQ"))) == seq){%>selected<%}%>><%=i+1%></option>
		<%}%>
            </select>
            번
        </td>
        <td align="center" width="540"> <a href="javascript:pass('b')"><img src="/acar/images/center/button_acc_back.gif" align="absmiddle" border="0"></a> &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:pass('n');"><img src="/acar/images/center/button_acc_next.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr> 
        <td align="right" colspan="2"><a href="javascript:self.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
