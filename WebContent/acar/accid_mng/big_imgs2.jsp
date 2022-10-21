<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.common.*"%>
<jsp:useBean id="p_bean" class="acar.accid.PicAccidBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String filename = request.getParameter("filename")==null?"":request.getParameter("filename");
	String file_path = request.getParameter("file_path")==null?"":request.getParameter("file_path");
		
         	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	//계약:고객관련
	RentListBean base = a_cad.getCont_View(m_id, l_cd);	
	
	PicAccidBean pa_r [] = as_db.getPicAccidList(c_id, accid_id);
	int size = pa_r.length;
	
	if  ( file_path.equals("")) {
		p_bean = pa_r[0];
		file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(p_bean.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");                		               		
	}
	
//	String file_path="";
		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var size = <%=size%>;
	var imgs = new Array();
	
	<%for(int i=0; i<size; i++){
		p_bean = pa_r[i];%>		
	imgs[<%=i%>] = <%=p_bean.getFilename()%>;
	
	<%}%>	
	
//	function chang_img(img_value){
//		document.carImg.src = 'https://fms3.amazoncar.co.kr/data/accidImg/'+img_value+'.gif';
//	}
	
	function pass(cmd){		
		if(cmd == 'b'){//이전
			if(document.form1.seq.value == '1'){
				alert('이전 사진은 없습니다.');		
			}else{
				document.carImg.src = 'https://fms3.amazoncar.co.kr/data/'+document.form1.file_path.value+ imgs[toInt(document.form1.seq.value)-2]+'.gif';
				document.form1.seq[toInt(document.form1.seq.value)-2].selected = true;
			}
		}else{//다음
			if(document.form1.seq.value == size){
				alert('다음 사진은 없습니다.');		
			}else{				
				document.carImg.src = 'https://fms3.amazoncar.co.kr/data/'+document.form1.file_path.value+  imgs[toInt(document.form1.seq.value)]+'.gif';
				document.form1.seq[toInt(document.form1.seq.value)].selected = true;				
			}		
		}
	}	
	
	function move(){	
	//    alert(	toInt(document.form1.seq.value)-1 );
	  
	 document.carImg.src = 'https://fms3.amazoncar.co.kr/data/'+document.form1.file_path.value+imgs[toInt(document.form1.seq.value)-1]+'.gif';
	}		
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='file_path' value='<%=file_path%>'>

<table border=0 cellspacing=0 cellpadding=0 width=640>
    <tr> 
        <td colspan="2">&nbsp;&nbsp;<img src=/acar/images/center/arrow_carnum.gif align=absmiddle> : <span class=style2><%=base.getCar_no()%></span></td>
    </tr>
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
        			<%if(seq.equals("")){%>
        			<%	for(int i=0; i<1; i++){
        					p_bean = pa_r[i];
        					file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(p_bean.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");		                	    
        					%>
        				<img name="carImg" src="https://fms3.amazoncar.co.kr/data/<%=file_path%><%=p_bean.getFilename()%>.gif" border="0" width="640" height="480">
        	  		<%	}%>		  
        		  	<%}else{%>
        		  		<img name="carImg" src="https://fms3.amazoncar.co.kr/data/<%=file_path%><%=filename%>.gif" border="0" width="640" height="480">		  
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
        <%for(int i=0; i<size; i++){
			p_bean = pa_r[i]; 
	//		file_path = AddUtil.replace(AddUtil.replace(AddUtil.replace(p_bean.getFile_path(),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/");		    
			
			%>		
          <option value="<%=i+1%>" <%if(seq.equals(p_bean.getSeq()))%>selected<%%>><%=p_bean.getSeq()%></option>
		<%}%>
        </select>
        번</td>
        <td align="center" width="540"> <a href="javascript:pass('b')"><img src="/acar/images/center/button_acc_back.gif" align="absmiddle" border="0"></a> &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:pass('n');"><img src="/acar/images/center/button_acc_next.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr> 
        <td align="right" colspan="2"><a href="javascript:self.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>
