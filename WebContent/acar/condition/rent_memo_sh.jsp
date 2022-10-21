<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.* "%>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
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
	
	
%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5> 계약만료 메모 </span></span></td>
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
		                    <%  	//기본정보
                    				Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
									//계약기본정보
									ContBaseBean base = a_db.getCont(m_id, l_cd);
									//영업소 담당자
									CommiBean emp1 	= a_db.getCommi(m_id, l_cd, "1");%>
                            <tr> 
                                <td width='15%' class='title'>계약번호</td>
                                <td width=15%>&nbsp;<%=l_cd%></td>
                                <td width='15%' class='title'>상호(성명)</td>
                                <td>&nbsp;<%=fee.get("FIRM_NM")%>&nbsp;<%=fee.get("CLIENT_NM")%></td>
                                <td width="15%" class='title'>차량번호</td>
                                <td width=15%>&nbsp;<%=fee.get("CAR_NO")%></td>		  
                            </tr>
                            <tr> 
                                <td width='15%' class='title'>영업구분</td>
                                <td width=15%>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}%></td>
                                <td class='title'>영업사원</td>
                                <td colspan='3'>&nbsp;<%if(bus_st.equals("2")){%><font color='#999999'><%=emp1.getEmp_nm()%>(<%=emp1.getCar_off_nm()%>)</font><%}%></td>
                            </tr>
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
            		      
                    		<tr>	
                    			<td width='15%' class='title'>작성자</td> 
                    			<td width='15%' class='title'>작성일</td> 			
                                <td width='15%' class='title'>계약진행자</td>                    		                       		  			
                                <td width='55%' class='title'>메모</td>					
                    		</tr>
                    	
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
		</td>
	</tr>
    <tr>
        <td colspan='2'>
	    <iframe src="/acar/condition/rent_memo_sh_in.jsp?auth_rw=<%=auth_rw%>&tm_st=<%=tm_st%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&mng_id=<%=mng_id%>" name="i_no" width="100%" height="230" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
</table>
</body>
</html>
