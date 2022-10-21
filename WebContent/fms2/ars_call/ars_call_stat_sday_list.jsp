<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*, acar.car_sche.*, acar.user_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String id 	= request.getParameter("id")==null?"":request.getParameter("id");
	
	Hashtable ht = wc_db.ArsCallStatLogUsers(id);	
	
	CarScheBean cs_bean1 = csd.getCarScheVacBean(String.valueOf(ht.get("USER_ID1")), String.valueOf(ht.get("CALL_DT")));
	CarScheBean cs_bean2 = csd.getCarScheVacBean(String.valueOf(ht.get("USER_ID2")), String.valueOf(ht.get("CALL_DT")));
	CarScheBean cs_bean3 = csd.getCarScheVacBean(String.valueOf(ht.get("USER_ID3")), String.valueOf(ht.get("CALL_DT")));
%>


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
<form name='form1' action='ars_call_stat_base_list.jsp' method='post' target='t_content'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS 파트너 </span></td>
	  </tr>    
    <tr>
        <td class=h></td>
    </tr>	  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='15%' class='title'>거래처명</td>
                    <td width='55%'>&nbsp;<%=ht.get("FIRM_NM")%></td>                    
                    <td width='15%' class='title'>차량번호</td>
                    <td width='15%'>&nbsp;<%=ht.get("CAR_NO")%></td>                    
                </tr> 
            </table>
	    </td>
    </tr>                     
    <tr>
        <td class=h></td>
    </tr>	  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>                 
                <tr>
                    <td width='15%' class='title'>구분</td>                                    
                    <td width='20%' class='title'>지점</td>
                    <td width='20%' class='title'>성명</td>
                    <td width='20%' class='title'>연락처</td>
                    <td width='25%' class='title'><%=String.valueOf(ht.get("CALL_DT"))%> 업무대체자</td>
                </tr> 
                <tr>
                    <td class='title'>담당자(정)</td>
                    <td align='center'><%=ht.get("BR_NM1")%></td>                    
                    <td align='center'><%=ht.get("USER_NM1")%></td>
                    <td align='center'><%=ht.get("USER_M_TEL1")%></td>
                    <td align='center'><%if(!cs_bean1.getWork_id().equals("")){%><%=umd.getUserNm(cs_bean1.getWork_id())%><%} %></td>
                </tr>      
                <tr>
                    <td class='title'>파트너(부1)</td>
                    <td align='center'><%=ht.get("BR_NM2")%></td>                    
                    <td align='center'><%=ht.get("USER_NM2")%></td>
                    <td align='center'><%=ht.get("USER_M_TEL2")%></td>
                    <td align='center'><%if(!cs_bean2.getWork_id().equals("")){%><%=umd.getUserNm(cs_bean2.getWork_id())%><%} %></td>               
                </tr>   
                <tr>
                    <td class='title'>파트너(부2)</td>
                    <td align='center'><%=ht.get("BR_NM3")%></td>                    
                    <td align='center'><%=ht.get("USER_NM3")%></td>
                    <td align='center'><%=ht.get("USER_M_TEL3")%></td>   
                    <td align='center'><%if(!cs_bean3.getWork_id().equals("")){%><%=umd.getUserNm(cs_bean3.getWork_id())%><%} %></td>                
                </tr>                                                          
            </table>
	    </td>
    </tr>                       	        
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
