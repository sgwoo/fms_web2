<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.common.*, java.util.*, acar.car_accident.*"%>
<jsp:useBean id="ma_bean" class="acar.car_accident.MyAccidBean" scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5><%if(tm_st.equals("1")){%>면책금 메모<%}else if(tm_st.equals("2")){%>휴차료 메모<%}else if(tm_st.equals("3")){%>대차료 메모<%}else if(tm_st.equals("4")){%>해지정산금 메모<%}else if(tm_st.equals("5")){%>과태료 메모<%}else if(tm_st.equals("9")){%>대손채권 메모<%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align=right>	
        	<table width=100% border=0 cellspacing=0 cellpadding=0>
        	    <tr>
        	        <td class=line2></td>
        	    </tr>
        	    <tr>
        	        <td class='line'>	 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                    <%if(tm_st.equals("2")){
            				AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
            				ma_bean = a_cad.getMyAccid(c_id, accid_id);%>
                            <tr> 
                                <td width='15%' class='title'>계약번호</td>
                                <td width='30%'>&nbsp;<%=l_cd%></td>
                                <td width='15%' class='title'>담당자</td>
                                <td width="40%" colspan="3">&nbsp;<%=c_db.getNameById(mng_id, "USER")%></td>
                            </tr>
                            <tr> 
                                <td width='15%' class='title'>보험담당자</td>
                                <td align="center"><%=ma_bean.getIns_nm()%></td>
                                <td width='15%' class='title'>연락처1</td>
                                <td width="15%" align="center"><%=ma_bean.getIns_tel()%></td>
                                <td width="15%" class='title'>연락처2</td>
                                <td width="15%" align="center"><%=ma_bean.getIns_tel2()%></td>
                            </tr>
                    		<%}else if(tm_st.equals("9")){
                    				//기본정보
                    				Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);%>
                            <tr> 
                                <td width='15%' class='title'>계약번호</td>
                                <td width=15%>&nbsp;<%=l_cd%></td>
                                <td width='15%' class='title'>상호(성명)</td>
                                <td>&nbsp;<%=fee.get("FIRM_NM")%>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width="15%" class='title'>차량번호</td>
                                <td width=15%>&nbsp;<%=fee.get("CAR_NO")%></td>		  
                            </tr>
                    		<%}else{%>
                            <tr> 
                                <td width='15%' class='title'>계약번호</td>
                                <td width='30%'>&nbsp;<%=l_cd%></td>
                                <td width='15%' class='title'>담당자</td>
                                <td width="40%" colspan="3">&nbsp;<%=c_db.getNameById(mng_id, "USER")%></td>
                            </tr>
                    		<%}%>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
	    <td style='height:5'></td>
	</tr>  
    <tr>
        <td>	
        	<table width=100% border=0 cellspacing=0 cellpadding=0>
        	    <tr>
        	        <td class=line2></td>
        	    </tr>
        	    <tr>
        	        <td class='line'>	 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
            		        <%if(tm_st.equals("9")){%>
                            <tr>					
                                <td width='15%' class='title'>작성자</td>
                    		    <td width='15%' class='title'>작성일</td>
                    		    <td width='15%' class='title'>채권구분</td>					
                                <td width='55%' class='title'>내용</td>					
                    		</tr>
                    		<%}else{%>
                    		<tr>					
                                <td width='15%' class='title'>작성자</td>
                    		    <td width='15%' class='title'>작성일</td>
                    		    <td width='15%' class='title'>담당자</td>					
                                <td width='55%' class='title'>메모</td>					
                    		</tr>
                    		<%}%>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
		</td>
	</tr>
    <tr>
        <td colspan='2'>
	    <iframe src="/fms2/con_ins_m/ins_memo_sh_in.jsp?auth_rw=<%=auth_rw%>&tm_st=<%=tm_st%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&mng_id=<%=mng_id%>" name="i_no" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
</table>
</body>
</html>
