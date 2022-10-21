<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	
	//ARS call ��Ȳ
	Vector vt = wc_db.ArsCallStatSYear(s_yy);
	int vt_size = vt.size();
	
	long total_amt1[]	 		= new long[15];
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_syear_sc.jsp";
	fm.target="_self";
	fm.submit();
}

//�˾�
function display_pop(s_dd, s_st){
	var fm = document.form1;
	fm.gubun1.value = '6';
	fm.gubun2.value = s_st;
	if(s_dd == ''){
		fm.st_dt.value = "<%=s_yy%>-01-01";
		fm.end_dt.value = "<%=s_yy%>-12-31";
	}else{
		fm.st_dt.value = "<%=s_yy%>-"+s_dd+"-01";
		fm.end_dt.value = "<%=s_yy%>-"+s_dd+"-31";
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
<form name='form1' action='ars_call_stat_syear_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='st_dt' value=''>
<input type='hidden' name='end_dt' value=''>
<input type='hidden' name='s_st' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1560>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS���ſ�����Ȳ </span></td>
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
							<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
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
                    <td rowspan='3' width='50' class='title'>�ͼӿ�</td>
                    <td colspan='5' class='title'>����</td>
                    <td colspan='5' class='title'>��������</td>
                    <td colspan='3' class='title'>��������</td>                    
                </tr>
                <tr>
                    <td rowspan='2' width='70' class='title'>��ȭ</td>
                    <td rowspan='2' width='70' class='title'>�ȳ���</td>
                    <td rowspan='2' width='70' class='title'>����û</td>
                    <td rowspan='2' width='70' class='title'>�������</td>
                    <td rowspan='2' width='70' class='title'>�Ұ�</td>
                    <td rowspan='2' width='70' class='title'>���</td>
                    <td rowspan='2' width='70' class='title'>����⵿</td>
                    <td rowspan='2' width='70' class='title'>����</td>
                    <td rowspan='2' width='70' class='title'>��Ÿ</td>
                    <td rowspan='2' width='70' class='title'>�˼�����</td>
                    <td colspan='2' class='title'>���</td>
                    <td rowspan='2' width='70' class='title'>����</td>
                </tr>
                <tr>
                    <td width='70' class='title'>�Ǽ�</td>
                    <td width='70' class='title'>�ݾ�</td>
                </tr>                
                <%	long call_amt = 0; 
                	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);	
				            
			            	call_amt = AddUtil.parseLong(String.valueOf(ht.get("CALL_AMT")));
				            
				            for(int j = 1 ; j <= 12 ; j++){
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT"+j)));
							}
				            
				            total_amt1[13]	= total_amt1[13] + call_amt;
				%>
                <tr>
                    <td align=center><%=ht.get("CALL_DT")%>��</td>
                    <%for(int j = 1 ; j <= 11 ; j++){ %>
                    <td align=center><a href="javascript:display_pop('<%=ht.get("CALL_DT")%>','<%=j%>')"><%=ht.get("CNT"+j)%></a></td>
                    <%} %>
                    <td align=right><%=AddUtil.parseDecimalLong(call_amt) %></td>
                    <td align=center><a href="javascript:display_pop('<%=ht.get("CALL_DT")%>','12')"><%=ht.get("CNT12")%></a></td>                    
                </tr>                   
		            <%	}%>     
                <tr>
                    <td class='title'>�հ�</td>
                    <%for(int j = 1 ; j <= 11 ; j++){ %>
                    <td align="center"><a href="javascript:display_pop('','<%=j%>')"><%=AddUtil.parseDecimalLong(total_amt1[j])%></a></td>
                    <%} %>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1[13])%></td>
                    <td align="center"><a href="javascript:display_pop('','12')"><%=AddUtil.parseDecimalLong(total_amt1[12])%></a></td>
                </tr>				                       		            
		            <%}else{%>
                <tr>
                    <td colspan="14" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
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

