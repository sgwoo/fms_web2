<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=ins_car_use_sc_in_excel.xls");
%>

<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String print_yn = request.getParameter("print_yn")==null?"":request.getParameter("print_yn");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt1 =0;
	int cnt2 =0;
	int cnt3 =0;
	int cnt4 =0;
	int cnt5 =0;
	int cnt6 =0;
	int cnt7 =0;
	int cnt8 =0;
	int cnt9 =0;
	int cnt10 =0;
	int cnt11 =0;
	int cnt12 =0;
		
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatSearchList(gubun1, "1");
	int vt_size = vt.size();
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">

<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr> 
        <td><span class=style2>피보험자 아마존카</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='15%' class='title'>구분</td>
		    <td width='15%' class='title'>차종</td>
		    <td width='10%' class='title'>소분류순번</td>				
		    <td width='5%' class='title'>총건수</td>				
		    <td width='5%' class='title'>21세</td>				
		    <td width='5%' class='title'>22세</td>				
		    <td width='5%' class='title'>24세</td>				
		    <td width='5%' class='title'>26세</td>				
		    <td width='5%' class='title'>28세</td>				
		    <td width='5%' class='title'>30세</td>				
		    <td width='4%' class='title'>35세</td>				
		    <td width='4%' class='title'>35세~49세</td>				
		    <td width='4%' class='title'>43세</td>				
		    <td width='4%' class='title'>48세</td>				
		    <td width='4%' class='title'>모든연령</td>				
		    <td width='5%' class='title'>26세보험료</td>				
    </tr>		    
<%
	if(vt_size > 0)
	{
%>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));		

%>
				<tr>
					<td width='15%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='15%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("승용소형A")){%>모닝,스파크
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용소형B")){%>아반떼,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용중형")){%>쏘나타,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용대형")){%>그랜저,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 1600cc 이하")){%>QM3,티볼리
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 이하")){%>투싼,스포티지,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 이하")){%>싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9인승")){%>카니발,코란도,투리스모
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>										
					</td>
					<td width='10%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "1", String.valueOf(ht.get("S_ST_CD")), "2"))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                    
                </tr>	
			</table>
		</td>
    </tr>		
		
<%                     
	}                  
%>
    <tr> 
        <td> <span class=style2>피보험자 고객</span></td>
    </tr>
    
    
    <%		vt = ai_db.getInsureStatSearchList(gubun1, "2");
		vt_size = vt.size();
		cnt1 =0;
		cnt2 =0;
		cnt3 =0;
		cnt4 =0;
		cnt5 =0;
		cnt6 =0;
		cnt7 =0;
		cnt8 =0;
		cnt9 =0;
		cnt10 =0;
		cnt11 =0;
		cnt12 =0;		
    %>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line' width='100%'>
	    <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='15%' class='title'>구분</td>
		    <td width='15%' class='title'>차종</td>
		    <td width='10%' class='title'>소분류순번</td>				
		    <td width='5%' class='title'>총건수</td>				
		    <td width='5%' class='title'>21세</td>				
		    <td width='5%' class='title'>22세</td>				
		    <td width='5%' class='title'>24세</td>				
		    <td width='5%' class='title'>26세</td>				
		    <td width='5%' class='title'>28세</td>				
		    <td width='5%' class='title'>30세</td>				
		    <td width='4%' class='title'>35세</td>				
		    <td width='4%' class='title'>35세~49세</td>				
		    <td width='4%' class='title'>43세</td>				
		    <td width='4%' class='title'>48세</td>				
		    <td width='4%' class='title'>모든연령</td>				
		    <td width='5%' class='title'>26세보험료</td>				
		</tr>    
<%
	if(vt_size > 0)
	{
%>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			cnt1 	= cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT")));
			cnt2 	= cnt2 + AddUtil.parseInt(String.valueOf(ht.get("AGE_21_CNT")));
			cnt3 	= cnt3 + AddUtil.parseInt(String.valueOf(ht.get("AGE_24_CNT")));
			cnt4 	= cnt4 + AddUtil.parseInt(String.valueOf(ht.get("AGE_26_CNT")));
			cnt5 	= cnt5 + AddUtil.parseInt(String.valueOf(ht.get("AGE_30_CNT")));
			cnt6 	= cnt6 + AddUtil.parseInt(String.valueOf(ht.get("AGE_35_CNT")));
			cnt7 	= cnt7 + AddUtil.parseInt(String.valueOf(ht.get("AGE_43_CNT")));
			cnt8 	= cnt8 + AddUtil.parseInt(String.valueOf(ht.get("AGE_48_CNT")));
			cnt9 	= cnt9 + AddUtil.parseInt(String.valueOf(ht.get("AGE_ETC_CNT")));
			cnt10 	= cnt10 + AddUtil.parseInt(String.valueOf(ht.get("AGE_22_CNT")));
			cnt11 	= cnt11 + AddUtil.parseInt(String.valueOf(ht.get("AGE_28_CNT")));
			cnt12 	= cnt12 + AddUtil.parseInt(String.valueOf(ht.get("AGE_3549_CNT")));

%>
				<tr>
					<td width='15%' align='center'><%=ht.get("GUBUN")%></td>
					<td width='15%' align='center'>
					    <%      if(String.valueOf(ht.get("GUBUN")).equals("승용소형A")){%>모닝,스파크
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용소형B")){%>아반떼,K3
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용중형")){%>쏘나타,K5
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("승용대형")){%>그랜저,K7
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 1600cc 이하")){%>QM3,티볼리
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 이하")){%>투싼,스포티지,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("5~6인승 짚 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 이하")){%>싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("7인승 2000cc 초과")){%>맥스크루즈,싼타페,쏘렌토
					    <%}else if(String.valueOf(ht.get("GUBUN")).equals("9인승")){%>카니발,코란도,투리스모
					    <%}else {%><%=ht.get("CAR")%>
					    <%}%>					
					</td>
					<td width='10%' align='center'><%=ht.get("S_ST_CD")%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_21_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_22_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_24_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_26_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_28_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_30_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_35_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_3549_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_43_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_48_CNT")))%></td>
					<td width='4%' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AGE_ETC_CNT")))%></td>
					<td width='5%' align='right'><%=AddUtil.parseDecimal(ai_db.getInsureStatSearchListAmt(gubun1, "2", String.valueOf(ht.get("S_ST_CD")), "2"))%></td>
				</tr>
<%
		}
%>
                <tr> 
                    <td class="title" colspan='3'>합계</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt1)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt2)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt10)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt3)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt4)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt11)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt5)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt6)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt12)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt7)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt8)%></td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(cnt9)%></td>
                    <td class="title"></td>
                </tr>	
	    </table>
	</td>
    </tr>		
		
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
