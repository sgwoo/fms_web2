<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*, acar.user_mng.*,acar.common.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/off/cookies.jsp" %>

<%
	//스캔관리 페이지
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
	String content_code = "";
	String content_seq  = "";

	Vector attach_vt = new Vector();		
	int attach_vt_size = 0;		
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' method='post' >
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">

<input type='hidden' name="seq" value="">
<input type='hidden' name="remove_seq" value="">
<table border="0" cellspacing="0" cellpadding="0" width=670>
   
   
  <%if(ch_r.length > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차등록증 스캔</span></td>
        <td align="right"></td>
    </tr>	
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td class="title" width='7%'>연번</td>
                  <td class="title" width='17%'>구분</td>
                  <td class="title" width='37%'>설명</td>
                  <td class="title" width='22%'>파일보기</td>
                  <td class="title" width='17%'>등록일</td>
                </tr>
                <%
    				for(int i=0; i<ch_r.length; i++){
    			      	  ch_bean = ch_r[i];	
    			//		if(ch_bean.getScanfile().equals("")) continue;
    					
				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){	    	    					
    		%>
                <tr>
                  <td align="center"><%= i+1 %></td>
                  <td align="center">
                    자동차등록증
    			  </td>
                  <td align="center">
    			  		  <% if(ch_bean.getCha_cau().equals("1")){%>
                          사용본거지 변경 
                          <%}else if(ch_bean.getCha_cau().equals("2")){%>
                          용도변경 
                          <%}else if(ch_bean.getCha_cau().equals("3")){%>
                          기타 
                          <%}else if(ch_bean.getCha_cau().equals("4")){%>
                          없음
                          <%}else if(ch_bean.getCha_cau().equals("5")){%>신규등록<%}%>	
    			  </td>
                  <td align="center">
					<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);    								
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
    						<%	}%>		    			
    						<%}%> 									  
				  </td>
                  <td align="center"><%=ch_bean.getCha_dt()%><%=c_db.getNameById(ch_bean.getReg_id(),"USER")%></td>
                </tr>
                <% 		}%>    
                <% 	}%>
            </table>
        </td>
    </tr>	  
     <% 	} %>	  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
