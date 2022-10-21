<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*,jxl.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="ClientBean" 	scope="page" class="acar.client.ClientBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	
	String vid[] = request.getParameterValues("ch_l_cd");
	String doc_id[] = request.getParameterValues("ch_doc_id");
	
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	int vid_size = vid.length;
	
	Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	//System.out.println("현재날짜 : "+ sdf.format(d));
	String filename = sdf.format(d)+"일자_최고서발송대장.xls";
	filename = java.net.URLEncoder.encode(filename, "UTF-8");
	response.setContentType("application/octer-stream");
	response.setHeader("Content-Transper-Encoding", "binary");
	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
	response.setHeader("Content-Description", "JSP Generated Data");
	
	
	%>

<html>
<head><title>FMS</title>
<script src='/include/common.js'></script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr> 
      <td class="line">
        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
         <tr align="center">  
            <td class='title' style="background-color:#e2e7ff;">연번</td>
            <td class='title' style="background-color:#e2e7ff;">주소</td>
            <td class='title' style="background-color:#e2e7ff;">참조</td>
            <td class='title' style="background-color:#e2e7ff;">연락처</td>
          </tr>
 <% 	
           if(vid_size > 0){
				for(int i=0; i<vid_size; i++){ 
					FineDocBn = FineDocDb.getFineDoc(doc_id[i]);
					ClientBean = al_db.getClient(FineDocBn.getGov_id());
					
					%>	         

            <tr> 
            <td align="center"><%=i+1%></td>
            <td align="left"><%=FineDocBn.getGov_addr()%></td>
            <td align="left"><%=FineDocBn.getGov_nm()%>&nbsp;<%=FineDocBn.getMng_dept()%></td>
            <td align="center"><%=ClientBean.getM_tel()%></td>
          </tr>
          <% 	}
			} %>
        </table>
      </td>
      <td>&nbsp;</td>	  
    </tr>
</table>
</body>
</html>

