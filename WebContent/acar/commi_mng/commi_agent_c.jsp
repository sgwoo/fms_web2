<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.commi_mng.*, acar.user_mng.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"2":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list 	= request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");

	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	co_bean = cod.getCarOffBean(car_off_id);

	Vector commis = ac_db.getCommiAgentList("", "", "", "", "", "", "", "99", co_bean.getCar_off_nm(), "1", "1");
	int commi_size = commis.size();	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_list(){
		location.href = "./commi_agent_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>&f_list=<%=f_list%>";
	}
//-->
</script>
</head>

<body leftmargin=15>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='car_off_id' value='<%=car_off_id%>'>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 영업사원관리 > <span class=style5>에이전트수당관리</span></span></td>
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
	    <a href="javascript:go_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>&nbsp;
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>관리구분</td>
		    <td width=20%>&nbsp;
		        <%if(co_bean.getCar_off_st().equals("3")){%>법인<%}%>
                    	<%if(co_bean.getCar_off_st().equals("4")){%>개인사업자<%}%>
		    </td>			    	
		    <td width=12% class=title>소속구분</td>
                    <td width=24%>&nbsp;
                    	<%if(co_bean.getAgent_st().equals("1")){%>에이전트<%}%>
                    	<%if(co_bean.getAgent_st().equals("2")){%>프리랜서<%}%>
                    </td>
                    <td class=title width=12%>최초등록일</td>
                    <td width=20%>&nbsp;
                        <%=AddUtil.ChangeDate2(co_bean.getReg_dt())%></td>                    
		</tr>
                <tr>                    
                    <td class=title>상호/성명</td>
		    <td>&nbsp;
		        <%=co_bean.getCar_off_nm()%></td>			    	
                    <td class=title>사업자구분</td>
               	    <td>&nbsp;
                    	<%if(co_bean.getEnp_st().equals("1")){%>개인<%}%>
                    	<%if(co_bean.getEnp_st().equals("2")){%>법인<%}%>
                    </td>
               	    <td class=title>사업자/주민번호</td>
               	    <td>&nbsp;
               	        <%=AddUtil.ChangeSsnBdt(co_bean.getEnp_no())%></td>                    
                </tr>		
                <tr>                    
                    <td class=title>대표자</td>
		    <td>&nbsp;
		        <%=co_bean.getOwner_nm()%></td>			    	
                    <td class=title>대표전화</td>
               	    <td>&nbsp;
               	        <%=co_bean.getCar_off_tel()%></td>
               	    <td class=title>팩스</td>
               	    <td>&nbsp;
               	        <%=co_bean.getCar_off_fax()%></td>                    
                </tr>
                <tr>
                    <td class=title>주소</td>
               	    <td colspan=5>&nbsp;
               		<%=co_bean.getCar_off_post()%>&nbsp;<%=co_bean.getCar_off_addr()%></td>
                </tr>    
            </table>
        </td>
    </tr>    
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
            	<tr>			    	
                    <td width=12% class=title>사업자등록구분</td>
		    <td width=20%>&nbsp;
		        <%if(co_bean.getEnp_reg_st().equals("1")){%>사업자등록사업자<%}%>
                    	<%if(co_bean.getEnp_reg_st().equals("2")){%>사업자미등록자<%}%>
		    </td>			    	
		    <td width=12% class=title>거래증빙</td>
                    <td width=24%>&nbsp;
                    	<%if(co_bean.getDoc_st().equals("1")){%>원천징수<%}%>
                    	<%if(co_bean.getDoc_st().equals("2")){%>세금계산서<%}%>
                    </td>
                    <td class=title width=12%>수수료지급</td>
                    <td width=20%>&nbsp;
                    	<%if(co_bean.getEst_day().equals("")){%>개별<%}%>
                    	<%if(!co_bean.getEst_day().equals("")){%>매월<%=co_bean.getEst_day()%>일<%}%>                    	
                    </td>
		</tr>                                            
                <tr>
                    <td class=title>거래처코드</td>
               	    <td>&nbsp;
               	        <%=co_bean.getVen_code()%>
               	    </td>
               	    <td class=title>세금계산서<br>수취구분</td>
               	    <td>&nbsp;
		        <%if(co_bean.getReq_st().equals("1")){%>개별<%}%>
                    	<%if(co_bean.getReq_st().equals("2")){%>월합<%}%>
                    	<%if(co_bean.getReq_st().equals("3")){%>없음<%}%>
		    </td>			
               	    <td class=title>지급구분</td>
               	    <td>&nbsp;
		        <%if(co_bean.getPay_st().equals("1")){%>월합<%}%>
                    	<%if(co_bean.getPay_st().equals("2")){%>개별건별<%}%>
		    </td>			
                </tr>                     
                <tr>
                    <td class=title>거래은행</td>
               	    <td>&nbsp;
		        <%=co_bean.getBank()%>					
               	    </td>
               	    <td class=title>계좌번호</td>
               	    <td>&nbsp;
               	        <%=co_bean.getAcc_no()%></td>
               	    <td class=title>예금주</td>
               	    <td>&nbsp;
               	        <%=co_bean.getAcc_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>&nbsp;</td>    	
    </tr>
    <%	if(commi_size > 0){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 cellpadding=0 width=100%>
            	<tr>
            		<td width=10% class=title>연번</td>
            		<td width=15% class=title>계약번호</td>
            		<td width=20% class=title>상호</td>
            		<td width=15% class=title>차량번호</td>
            		<td width=20% class=title>대여개시일</td>
            		<td width=20% class=title>지급수수료(부가세별도)</td>            		            		
            	</tr>
                <%	for(int i = 0 ; i < commi_size ; i++){
				Hashtable commi = (Hashtable)commis.elementAt(i);%>
            	<tr>
            		<td align=center><%=i+1%></td>
            		<td align=center><%=commi.get("RENT_L_CD")%></td>
            		<td align=center><%=commi.get("FIRM_NM")%></td>
            		<td align=center><%=commi.get("CAR_NO")%></td>
            		<td align=center><%=commi.get("RENT_START_DT")%></td>            		
            		<td align=right><%=Util.parseDecimal(String.valueOf(commi.get("DIF_AMT")))%></td>
            	</tr>
                <%	}%>
            </table>
        </td>
    </tr>                
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>
<!--

//-->
</script>  
</body>
</html>