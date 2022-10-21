<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String memo_st = request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(memo_st.equals("client") && client_id.equals("")){
		//계약기본정보
		ContBaseBean base = a_db.getCont(m_id, l_cd);
		client_id = base.getClient_id();
	}
	
	Vector memos = new Vector();
	int memo_size = 0;
	
	if(memo_st.equals("client")){
		memos = af_db.getCmsMemoOneMon(m_id, l_cd, r_st, fee_tm,  tm_st1, client_id);
		memo_size = memos.size();
	}else{
		memos = af_db.getCmsMemo(m_id, l_cd, r_st, fee_tm,  tm_st1);
		memo_size = memos.size();
	}
%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			FeeMemoBean memo = (FeeMemoBean)memos.elementAt(i);%>
		        <tr>
        		    <td width='12%' align='center'><%=memo.getRent_l_cd()%></td>				
        		    <td width='8%' align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
        		    <td width='9%' align='center'><%=memo.getReg_dt()%></td>
        		    <td width='11%' align='center'><%=memo.getSpeaker()%></td>
        		    <td width='60%'>
		                <table>
            			    <tr>
            				    <td><%=Util.htmlBR(memo.getContent())%></td>
            			    </tr>
			            </table>
		            </td>
		        </tr>
<%		}
	}else{%>
		        <tr>
		            <td colspan='5' align='center'>등록된 데이타가 없습니다 </td>
		        </tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</body>
</html>
