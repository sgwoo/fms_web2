<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
%>

<html>
<head>
<title><%=car_no%> 차량사진 일괄등록</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		fm = document.form1;		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.APPRSL%>";
		fm.target = "_blank";
		fm.submit();
	}
	
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
<input type='hidden' name="user_id" 		value="<%=user_id%>">
<input type='hidden' name="br_id"   		value="<%=br_id%>">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='car_no' value='<%=car_no%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 영업지원 > <span class=style5>차량사진 일괄등록</span></span></td>
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
                  <td width="4%" class=title>연번</td>
                  <td width="10%" class=title>구분</td>				  
                  <td width="10%" class=title>썸네일</td>
                  <td width="66%" class=title>파일</td>		                    
                  <td width="10%" class=title>보기</td>
                </tr>	 
                
                <%
                	for(int i=0;i<8;i++){
                	
                		//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                		
										int idx   = 0;
    								String nm = "";    				
    				
                		if(i==1){
                			idx = 1;
											nm = "앞측";
										}else if(i==4){
											idx = 2;
											nm = "실내1";
										}else if(i==2){
											idx = 3;
											nm = "뒤";
										}else if(i==3){
											idx = 4;
											nm = "뒤측";
										}else if(i==0){
											idx = 5;
											nm = "앞";
										}else if(i==5){
											idx = 6;
											nm = "실내2";
										}else if(i==6){
											idx = 7;
											nm = "실내3";
										}else if(i==7){
											idx = 8;
											nm = "실내4";
										}
	
				String content_code = "APPRSL";
				String content_seq  = c_id+""+String.valueOf(idx);

				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				int attach_vt_size = attach_vt.size();	

				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
    						Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>               
                
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=nm%></td>
                    <td align="center"><img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="66" height="53"></td>	
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                    <td align="center"><a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></td>
                </tr>	
                <%
                			}
                		}else{
                %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=nm%></td>
                    <td align="center"><img src=../images/center/no_photo.gif align=absmiddle name="f"></td>	
                    <td align="center">
                        <input type="file" name="file" size="60" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.APPRSL%>'>        			
                    </td>
                    <td align="center"> </td>
                </tr>	                              
                <%		}%>                
                <%	}%>
                

            </table>
        </td>
    </tr>
    <tr>
        <td>☞ 파일을 선택한 것만 등록됩니다.</td>
    </tr>
    <tr>
        <td>☞ 기존 파일을 삭제후 새로운 파일을 등록할 수 있습니다.</td>
    </tr>
    <tr>	
        <td align="right">
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            
        </td>
    </tr>    
  </table>
</form>
</body>
</html>