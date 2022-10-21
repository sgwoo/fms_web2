<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*"%>
<%@ page import="acar.util.*, acar.fee.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	int total_su = 0;
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector exts = ae_db.getEcarList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int grt_size = exts.size();
%>
<form name='form1' action='' target='' method="POST">
<input type='hidden' name='grt_size' value='<%=grt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
			    <tr>
    				<td width='5%' class='title'>연번</td>
    				<td width='7%' class='title'>구분</td>
    				<td width='3%' class='title'>회차</td>
    				<td width='10%' class='title'>계약번호</td>
    				<td width='11%' class='title'>상호</td>
    				<td width='7%' class='title'>차량번호</td>
    				<td width='7%' class='title'>계약일</td>
    				<td width='6%' class='title'>대여방식</td>
    				<td width='6%' class='title'>대여기간</td>
    				<td width='8%' class='title'>대여개시일</td>
    				<td width='8%' class='title'>입금예정일</td>
    				<td width='8%' class='title'>금액</td>
    				<td width='8%' class='title'>수금일자</td>
    				<td width='6%' class='title'>최초영업</td>
			    </tr>
		
          <%	if(grt_size > 0){
			for(int i = 0 ; i < grt_size ; i++){
				Hashtable ext = (Hashtable)exts.elementAt(i);
				String tm_st1= "";
				if(String.valueOf(ext.get("GUBUN")).equals("보증금")) tm_st1 = "7";
				if(String.valueOf(ext.get("GUBUN")).equals("선납금")) tm_st1 = "8";
				if(String.valueOf(ext.get("GUBUN")).equals("개시대여료")) tm_st1 = "9";%>
                <tr> 
                    <td <%if(ext.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><a name="<%=i+1%>"><%=i+1%> 
              <%if(ext.get("USE_YN").equals("N")){%>
              (해약) 
              <%}%>
                </a></td>                  
                    <td align='center'><%=ext.get("GUBUN")%><%=ext.get("RENT_ST_NM")%></td>
                    <td align='right'><%=ext.get("EXT_TM")%>회&nbsp;</td>
                    <td align='center'><a href="javascript:parent.view_ext('<%=ext.get("RENT_MNG_ID")%>', '<%=ext.get("RENT_L_CD")%>', '<%=ext.get("CAR_MNG_ID")%>', '<%=ext.get("RENT_ST")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=ext.get("RENT_L_CD")%></a></td>
                    <td align='center'><span title='<%=ext.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ext.get("RENT_MNG_ID")%>', '<%=ext.get("RENT_L_CD")%>', '<%=ext.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ext.get("FIRM_NM")), 7)%></a></span></td>
                    <td align='center'><%=ext.get("CAR_NO")%></td>
                    <td align='center'>
					<%if(ext.get("GUBUN").equals("승계수수료")){%>
					<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_SUC_DT")))%>
					<%}else{%>
					<%=ext.get("RENT_DT")%>					
					<%}%>
					</td>
                    <td align='center'><%=ext.get("RENT_WAY")%></td>
                    <td align='center'><%=ext.get("CON_MON")%>개월</td>
                    <td align='center'><%=ext.get("RENT_START_DT")%></td>
                    <td align='center'><%=ext.get("EXT_EST_DT")%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ext.get("EXT_AMT")))%>원&nbsp;</td>
                    <td align='center'><%=ext.get("EXT_PAY_DT")%></td>
                    <td align='center'><%=c_db.getNameById(String.valueOf(ext.get("BUS_ID")),"USER")%></td>					
                </tr>
          <%		
				total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(ext.get("EXT_AMT")));
		  }%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>합계</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                </tr>
          <%	}else{%>
                <tr> 
                    <td align='center' colspan="14">등록된 데이타가 없습니다</td>
                </tr>
          <%	}%>
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
