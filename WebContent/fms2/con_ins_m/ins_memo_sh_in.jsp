<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.con_ins_m.*, acar.car_accident.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");

	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	Vector memos = new Vector();
	
	if(tm_st.equals("9")){
		memos = a_cad.getInsMemo(m_id, l_cd, c_id, tm_st, "", serv_id);
	}else{
		memos = a_cad.getInsMemo(m_id, l_cd, c_id, tm_st, accid_id, serv_id);
	}
	
	int memo_size = memos.size();
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function memo_delete(m_id, l_cd, c_id, tm_st, seq){
		var fm = document.form1;
		
		fm.m_id.value 	= m_id;
		fm.l_cd.value 	= l_cd;
		fm.c_id.value 	= c_id;						
		fm.tm_st.value 	= tm_st;
		fm.seq.value 	= seq;
		fm.cmd.value = "d";
		
		if(confirm('삭제하시겠습니까?')){	
			if(confirm('진짜로 삭제하시겠습니까?')){			
				fm.action='ins_memo_d_a.jsp';		
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
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='tm_st' value='<%=tm_st%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='cmd' value=''>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%	if(memo_size > 0){
		for(int i = 0 ; i < memo_size ; i++){
			InsMemoBean memo = (InsMemoBean)memos.elementAt(i);%>
                <tr>
        		  <td width='15%' align='center'><%=c_db.getNameById(memo.getReg_id(), "USER")%></td>
        		  <td width='15%' align='center'><%=AddUtil.ChangeDate2(memo.getReg_dt())%></td>
        		  <td width='15%' align='center'>
        		  <%if(tm_st.equals("9")){%>
        			  <%=memo.getAccid_id()%>
        		  <%}else{%>
        			  <%=memo.getSpeaker()%>
        		  <%}%>
        		  </td>					
                  <td width='55%'>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=Util.htmlBR(memo.getContent())%>&nbsp;&nbsp;
                                    <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("채권관리팀",ck_acar_id)) {%>									
									<a href="javascript:memo_delete('<%=memo.getRent_mng_id()%>','<%=memo.getRent_l_cd()%>','<%=memo.getCar_mng_id()%>','<%=memo.getTm_st()%>','<%=memo.getSeq()%>');" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_delete.gif"  align="absmiddle" border="0"></a>
									<%}%>
								</td>
                            </tr>
                        </table>
                    </td>
        		</tr>
        <%		}
        	}else{%>		
        		<tr>
        		  <td colspan='4' align='center'>등록된 데이타가 없습니다 </td>
        		</tr>
<%	}%>
	        </table>
	    </td>
    </tr>
</table>
</form>
</body>
</html>

