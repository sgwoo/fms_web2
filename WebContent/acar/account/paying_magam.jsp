<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	if(save_dt.equals(""))	save_dt = ad_db.getMaxSaveDt("stat_incom_pay");
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	vt = ac_db.getStatIncomPay("", "P", save_dt);
	vt_size = vt.size();
	
	String reg_dt		= "";
	if(vt.size()>0){
		for(int i=0; i<vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			reg_dt			= String.valueOf(ht.get("REG_DT"));
		}
	}
	
	String gubun_nm[]	 	= new String[6];
	gubun_nm[0] = "할부금";
	gubun_nm[1] = "보험료";
	gubun_nm[2] = "과태료";
	gubun_nm[3] = "영업수당";
	gubun_nm[4] = "기타비용";
	gubun_nm[5] = "특소세";
	
   	long amt1[]	 			= new long[6];
	long amt2[]	 			= new long[6];
	long amt3[]	 			= new long[6];
	long amt4[]	 			= new long[6];
	long amt5[]	 			= new long[6];
	
   	int cnt1[]	 			= new int[6];
	int cnt2[]	 			= new int[6];
	int cnt3[]	 			= new int[6];
	int cnt4[]	 			= new int[6];
	int cnt5[]	 			= new int[6];
	
	int idx = 0;
	
	String gubun1 = "";
	String gubun2 = "";
	String gubun3 = "";
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//당일마감
	function save(){
		var fm = document.form1;	
		fm.target = 'i_no';
		fm.action = '/acar/admin/stat_end_null_200911.jsp';		
		fm.submit();	
	}
	

//-->
</script>
</head>

<body leftmargin=15>

<form name='form1' method='post' action='paying_magam.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='mode' value='30'>
<input type='hidden' name='from_page' value='/acar/account/paying_magam.jsp'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 수금관리 > <span class=style5>마감지출현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right"> 
        <%if(auth_rw.equals("6")){%>
        <a href="javascript:save();"><img src=../images/center/button_dimg.gif align=absmiddle border=0></a>
        <%}%>
        </td>
    </tr>
    <tr> 
        <td><iframe src="/acar/admin/stat_end_incom_pay_list.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&save_dt=<%=save_dt%>&from_page=/acar/account/paying_magam.jsp" name="i_list" width="100%" height="45" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
        </td>
    </tr>	
	<tr> 
        <td align="right"><img src=../images/center/arrow_gji.gif border=0 align=absmiddle> : <%=reg_dt%></td>
    </tr>
	
	<%for(int j=0; j<6; j++){
		for(int i=0; i<6; i++){
			cnt1[i] = 0;
			cnt2[i] = 0;
			cnt3[i] = 0;
			amt1[i] = 0;
			amt2[i] = 0;
			amt3[i] = 0;
		}%>									
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=gubun_nm[j]%> 현황</span></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width="16%"  class='title'>구분</td>
                    <td colspan="2" width="21%"  class='title'>당월</td>
                    <td colspan="2" width="21%"  class='title'>당일</td>
                    <td colspan="2" width="21%"  class='title'>연체</td>
                    <td colspan="2" width="21%"  class='title'>합계</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                    <td width=9% class='title'>건수</td>
                    <td width=12% class='title'>금액</td>
                </tr>				
          		<%	idx = 0;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(gubun_nm[j])){
								cnt1[idx] = cnt1[idx] + AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = cnt2[idx] + AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = cnt3[idx] + AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = amt1[idx] + AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = amt2[idx] + AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = amt3[idx] + AddUtil.parseLong((String)ht.get("DLY_AMT"));
							}
						}
					}
		 		%>
                <tr> 
                    <td align="center" class='title'>계획</td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
          		<%	idx = 1;
					if(vt.size()>0){
						for(int i=0; i<vt.size(); i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);
							if(String.valueOf(ht.get("GUBUN_NM")).equals(gubun_nm[j])){
								
								if(String.valueOf(ht.get("GUBUN_ST")).equals("잔액")) idx = 2;
								
								cnt1[idx] = AddUtil.parseInt((String)ht.get("MON_CNT"));
								cnt2[idx] = AddUtil.parseInt((String)ht.get("DAY_CNT"));
								cnt3[idx] = AddUtil.parseInt((String)ht.get("DLY_CNT"));
								amt1[idx] = AddUtil.parseLong((String)ht.get("MON_AMT"));
								amt2[idx] = AddUtil.parseLong((String)ht.get("DAY_AMT"));
								amt3[idx] = AddUtil.parseLong((String)ht.get("DLY_AMT"));
							%>
                <tr> 
                    <td align="center" class='title'><%=ht.get("GUBUN_ST")%></td>
                    <td align="right"><%=cnt1[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt1[idx])%></td>
                    <td align="right"><%=cnt2[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx])%></td>
                    <td align="right"><%=cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt3[idx])%></td>
                    <td align="right"><%=cnt2[idx]+cnt3[idx]%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(amt2[idx]+amt3[idx])%></td>
                </tr>		
				<%			}
						}
					}%>	
                <tr> 
                    <td align="center" class='title'>비율(%)</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt1[1]))/AddUtil.parseFloat(String.valueOf(cnt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt1[1]))/AddUtil.parseFloat(String.valueOf(amt1[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt2[1]))/AddUtil.parseFloat(String.valueOf(cnt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt2[1]))/AddUtil.parseFloat(String.valueOf(amt2[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(cnt3[1]))/AddUtil.parseFloat(String.valueOf(cnt3[0]))*100,2)%></td>
                    <td align="right"><%=AddUtil.parseFloatCipher(AddUtil.parseFloat(String.valueOf(amt3[1]))/AddUtil.parseFloat(String.valueOf(amt3[0]))*100,2)%></td>
                    <td align="right">-</td>
                    <td align="right">-</td>
                </tr>			
            </table>
        </td>
    </tr>				
	<%}%>								
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
