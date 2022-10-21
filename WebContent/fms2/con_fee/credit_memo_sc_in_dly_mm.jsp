<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, acar.fee.*, acar.user_mng.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String memo_st = request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(memo_st.equals("client") && client_id.equals("")){
		//계약기본정보
		ContBaseBean base = a_db.getCont(m_id, l_cd);
		client_id = base.getClient_id();
	}
	
	Vector memos = new Vector();
	int memo_size = 0;
	
	if(memo_st.equals("client")){
		memos = af_db.getFeeMemoClient("", "", client_id);
		memo_size = memos.size();
	}else{
		memos = af_db.getFeeMemoClient(m_id, l_cd, "");
		memo_size = memos.size();
	}
	
	String admin_yn = "";
	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){
		admin_yn = "Y";
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function memo_delete(r_st, tm_st1, fee_tm, seq){
		var fm = document.form1;
		
		fm.m_r_st.value 	= r_st;
		fm.m_tm_st1.value 	= tm_st1;
		fm.m_fee_tm.value 	= fee_tm;						
		fm.m_seq.value 		= seq;
		
		if(confirm('삭제하시겠습니까?')){	
			if(confirm('진짜로 삭제하시겠습니까?')){			
				fm.action='fee_memo_d_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}									
		}									
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='m_r_st' value=''>
<input type='hidden' name='m_tm_st1' value=''>
<input type='hidden' name='m_fee_tm' value=''>
<input type='hidden' name='m_seq' value=''>
<input type='hidden' name='from_page' value='credit_memo'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			FeeMemoBean memo = (FeeMemoBean)memos.elementAt(i);%>
	            <tr>
        		    <td width='8%' align='center'><%=memo.getMm_st2()%></td>
        		    <td width='12%' align='center'><%=memo.getRent_l_cd()%></td>
        		    <td width='8%' align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
        		    <td width='9%' align='center'><%=memo.getReg_dt()%><br><%=memo.getReg_dt_time()%></td>
        		    <td width='11%' align='center'><%=memo.getSpeaker()%></td>
        		    <td width='42%'>
		                <table>
            			    <tr>
            				    <td><%=Util.htmlBR(memo.getContent())%>
								<%if(memo.getMm_st().equals("dly_mm") && admin_yn.equals("Y")){%>
								&nbsp;&nbsp;<a href="javascript:memo_delete('<%=memo.getRent_st()%>','<%=memo.getTm_st1()%>','<%=memo.getFee_tm()%>','<%=memo.getSeq()%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_delete.gif"  align="absmiddle" border="0"></a>
								<%}%>
								</td>
            			    </tr>
			            </table>
		            </td>
		            <td width='10%' align='center'><%=AddUtil.ChangeDate2(memo.getPromise_dt())%></td>
		        </tr>
<%		}
	}else{%>
		        <tr>
		            <td colspan='7' align='center'>등록된 데이타가 없습니다 </td>
		        </tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
</body>
</html>
