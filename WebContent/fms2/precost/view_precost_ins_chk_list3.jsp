<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*, acar.user_mng.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();

	String cost_ym = request.getParameter("cost_ym")==null?"":request.getParameter("cost_ym");
	String cost_st = request.getParameter("cost_st")==null?"":request.getParameter("cost_st");
	String car_use = request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String com_id  = request.getParameter("com_id")==null?"":request.getParameter("com_id");
	String chk_st  = request.getParameter("chk_st")==null?"":request.getParameter("chk_st");
	
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	
	Vector vts = new Vector();
	int vt_size = 0;
	
	//보험선급비용 미처리스트
	if(cost_st.equals("2")){
		vts = ai_db.getInsurPrecostYmCngChkList(cost_ym, cost_st, car_use, com_id, chk_st);
		vt_size = vts.size();
	}
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
	long sum4 = 0;
	long sum5 = 0;
	long sum6 = 0;
	long sum7 = 0;
	long sum8 = 0;
	long sum9 = 0;
	long sum10 = 0;
	long sum11 = 0;
	long sum12 = 0;
	long sum13 = 0;
	long sum14 = 0;
	long sum15 = 0;
	long sum16 = 0;
	long sum17 = 0;
	long sum18 = 0;
	long sum19 = 0;
	long sum20 = 0;
	
	int  cnt1 = 0;
	int  cnt2 = 0;
	int  cnt3 = 0;
	int  cnt4 = 0;
	int  cnt5 = 0;
	int  cnt6 = 0;
	int  cnt7 = 0;
	int  cnt8 = 0;
	int  cnt9 = 0;
	
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기간비용 정산 체크 리스트</span></td>
    </tr>  
    <tr>
        <td>&nbsp;&nbsp;&nbsp;○ <%if(cost_st.equals("2")){%>보험료<%}else{%>자동차세<%}%>
	    </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td class=title>연번</td>
		    <td class=title>차량번호</td>
		    <td class=title >시작일</td>
		    <td class=title >종료일</td>			
		    <td class=title>총보험료</td>
		    <td class=title>변경보험료</td>
		    <td class=title>기간비용계</td>						
		    <td class=title>차액1</td>						
		    <td class=title>차액2</td>
			<td class=title>변경일자</td>											
			<td class=title>기간비용월</td>											
			<td class=title>기간비용금액</td>															
	      </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
		        <tr> 
        		    <td style="font-size:8pt" align='center'><%=i+1%></td>
        		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NO")%></td>
        		    <td style="font-size:8pt" align='center'><%=ht.get("INS_START_DT")%></td>
        		    <td style="font-size:8pt" align='center'><%=ht.get("INS_EXP_DT")%></td>		
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>						
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CH_AMT")))%></td>						
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("T_COST_AMT")))%></td>						
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CHK_AMT1")))%></td>						
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CHK_AMT2")))%></td>						
        		    <td style="font-size:8pt" align='center'><%=ht.get("CH_DT")%></td>
        		    <td style="font-size:8pt" align='center'><%=ht.get("COST_YM")%></td>					
        		    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(String.valueOf(ht.get("COST_AMT")))%></td>					
		        </tr>
  <%		}%>
	        </table>
	    </td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>		

	<tr>
		<td align='right'>
		  <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%><a href='view_precost_ins_chk_list3_a.jsp?cost_ym=<%=cost_ym%>&cost_st=<%=cost_st%>&car_use=<%=car_use%>&com_id=<%=com_id%>&chk_st=<%=chk_st%>' target='_blank'>[처리]</a>&nbsp;&nbsp;<%}%>
		  
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
