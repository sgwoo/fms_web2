<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*, acar.estimate_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");
	
	String var1 = e_db.getEstiSikVarCase("1", "", "ars_call_base_amt");//당직수당지급기준액
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatSMon(s_yy, s_mm);
	int vt_size = vt.size();
	
	long total_amt1[]	 		= new long[15];
	
	long total_cnt = 0;
	for (int i = 0 ; i < vt_size ; i++){
        Hashtable ht = (Hashtable)vt.elementAt(i);
        total_cnt = total_cnt + AddUtil.parseLong(String.valueOf(ht.get("CNT11")));        
	}
	
	long base_call_amt = 0;
	
	if(total_cnt > 0 ){
		base_call_amt =AddUtil.parseLong(var1)/total_cnt;
		base_call_amt = (long)AddUtil.parseDouble(AddUtil.calcMath("CEIL",String.valueOf(base_call_amt),-1)); //원단위절상
	}
	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_smon_sc.jsp";
	fm.target="_self";
	fm.submit();
}

//팝업
function display_pop(s_dd, s_st){
	var fm = document.form1;
	fm.gubun1.value = '6';
	fm.gubun2.value = s_st;
	if(s_dd == ''){
		fm.st_dt.value = "<%=s_yy%>-<%=s_mm%>-01";
		fm.end_dt.value = "<%=s_yy%>-<%=s_mm%>-<%=AddUtil.getMonthDate(AddUtil.parseInt(s_yy),AddUtil.parseInt(s_mm))%>";
	}else{
		fm.st_dt.value = "<%=s_yy%>-<%=s_mm%>-"+s_dd;
		fm.end_dt.value = fm.st_dt.value;
	}
	fm.action="ars_call_stat_sday_sc.jsp";		
	fm.target="_self";
	fm.submit();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_smon_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='st_dt' value=''>
<input type='hidden' name='end_dt' value=''>
<input type='hidden' name='s_st' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1630>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS수신월간현황 </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;
                        <select name="s_yy">
			  			<%for(int i=2020; i<=AddUtil.getDate2(1); i++){%>
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>년</option>
						<%}%>
						</select>						
			      &nbsp;
			      <select name="s_mm">
			  			<%for(int i=1; i<=12; i++){%>
							<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=i%>월</option>
						<%}%>
						</select>           
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	 	     
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='3' width='50' class='title'>일자</td>
                    <td rowspan='3' width='50' class='title'>요일</td>
                    <td colspan='5' class='title'>수신</td>
                    <td colspan='5' class='title'>업무구분</td>
                    <td colspan='3' class='title'>당직수당</td>                    
                </tr>
                <tr>
                    <td rowspan='2' width='70' class='title'>통화</td>
                    <td rowspan='2' width='70' class='title'>안내문</td>
                    <td rowspan='2' width='70' class='title'>상담요청</td>
                    <td rowspan='2' width='70' class='title'>연결실패</td>
                    <td rowspan='2' width='70' class='title'>소계</td>
                    <td rowspan='2' width='70' class='title'>사고</td>
                    <td rowspan='2' width='70' class='title'>긴급출동</td>
                    <td rowspan='2' width='70' class='title'>정비</td>
                    <td rowspan='2' width='70' class='title'>기타</td>
                    <td rowspan='2' width='70' class='title'>알수없음</td>
                    <td colspan='2' class='title'>대상</td>
                    <td rowspan='2' width='70' class='title'>비대상</td>
                </tr>
                <tr>
                    <td width='70' class='title'>건수</td>
                    <td width='70' class='title'>금액</td>
                </tr>                
                <%	long call_amt = 0; 
                	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);	
				            
				            if(!String.valueOf(ht.get("CALL_AMT")).equals("0")){
				            	call_amt = AddUtil.parseLong(String.valueOf(ht.get("CALL_AMT")));
				            }else{				            
				            	call_amt = AddUtil.parseLong(String.valueOf(ht.get("CNT11")))*base_call_amt;
			    	        	call_amt = (long)AddUtil.parseDouble(AddUtil.calcMath("CEIL",String.valueOf(call_amt),-1));
				            }
				            
				            for(int j = 1 ; j <= 12 ; j++){
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT"+j)));
							}
				            
				            total_amt1[13]	= total_amt1[13] + call_amt;
				%>
                <tr>
                    <td align=center><%=ht.get("CALL_DT")%></td>
                    <td align=center><%=ht.get("DAY_NM")%></td>
                    <%for(int j = 1 ; j <= 11 ; j++){ %>
                    <td align=center><a href="javascript:display_pop('<%=ht.get("CALL_DT")%>','<%=j%>')"><%=ht.get("CNT"+j)%></a></td>
                    <%} %>
                    <td align=right><%=AddUtil.parseDecimalLong(call_amt) %></td>
                    <td align=center><a href="javascript:display_pop('<%=ht.get("CALL_DT")%>','12')"><%=ht.get("CNT12")%></a></td>                    
                </tr>                   
		            <%	}%>     
                <tr>
                    <td colspan="2" class='title'>합계</td>
                    <%for(int j = 1 ; j <= 11 ; j++){ %>
                    <td align="center"><a href="javascript:display_pop('','<%=j%>')"><%=AddUtil.parseDecimalLong(total_amt1[j])%></a></td>
                    <%} %>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1[13])%></td>
                    <td align="center"><a href="javascript:display_pop('','12')"><%=AddUtil.parseDecimalLong(total_amt1[12])%></a></td>
                </tr>				                       		            
		            <%}else{%>
                <tr>
                    <td colspan="15" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>                     	        
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
