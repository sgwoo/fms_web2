<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<jsp:useBean id="p_bean" class="acar.off_anc.PropBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	int prop_id = request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String re_seq = request.getParameter("re_seq")==null?"":request.getParameter("re_seq");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	OffPropDatabase p_db = OffPropDatabase.getInstance();

   //제안 채택 여부 및 포상금액	
	p_bean = p_db.getPropBean(prop_id);

	
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='400'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line' width='390'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='20%' class='title'>제목</td>
                    <td colspan=3 align="center">&nbsp;<br><%=p_bean.getTitle()%><br>&nbsp;</td>                               
                </tr>
                <tr>
                    <td width='20%'  class='title'>채택여부</td>
                    <td width='40%' align="center">  <%if(p_bean.getUse_yn().equals("Y")){%>채택
			  	      <%} else if(p_bean.getUse_yn().equals("M")){%>수정채택
			  	      <%} else if(p_bean.getUse_yn().equals("O")){%>업무시정채택
			  	      <%} else if(p_bean.getUse_yn().equals("I")){%>정보제공
			          <%} else if(p_bean.getUse_yn().equals("N")){%>불채택 <% } %>
			        </td>
                    <td width='20%'  class='title'>포상금</td>
                    <td width='20%' align="center">&nbsp;<%=Util.parseDecimal(p_bean.getPrize())%></td>
               
                </tr>
            </table>
	    </td>
	    <td width='10'>&nbsp;</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
   
 
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
        		    <td width='20%' class='title'>작성자</td>
        		    <td width='58%' class='title'>점수</td>					
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>
    <tr>
	    <td colspan='2'>
	    <iframe src="c_eval_sh_in.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>&prop_id=<%=prop_id%>&seq=<%=seq%>&re_seq=<%=re_seq%>&use_id=<%=user_id%>" name="i_no" width="100%" height="200" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
</table>
</body>
</html>
