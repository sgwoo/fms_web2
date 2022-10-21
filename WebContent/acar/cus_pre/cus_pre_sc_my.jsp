<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, acar.account.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));
	
	long tot_dly_amt = 0;
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	
	//미수금정산 통계
	Hashtable settle = s_db.getSettleListStat("", "", "", "", "", "", "8", user_id);
	
	//전체 연체
	Vector feedps3 = ac_db.getFeeStat_Dlyper(br_id, "", "", "");
	if(feedps3.size() > 0){
		for (int i = 0 ; i < feedps3.size() ; i++){
			IncomingSBean feedp = (IncomingSBean)feedps3.elementAt(i);
			tot_dly_amt = Long.parseLong(feedp.getTot_amt2());
		}
	}
	
	//연체율
	Vector feedps = ad_db.getDlyBusStat(br_id, "0002", "");
	//연체율 부서순위
	/*Vector feedps2 = ad_db.getDlyBusStat(br_id,"0002","");
	int cnt = 0;
	for(int i=0; i<feedps2.size(); i++){
		IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
System.out.println("gubun="+feedp.getGubun());		
		if(user_id==feedp.getGubun())	cnt++;
	}*/
%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
				
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미수현황</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=10% class='title' align="center">구분</td>
                    <td colspan="2" class='title' align="center">선수금</td>
                    <td colspan="2" class='title' align="center">대여료</td>
                    <td colspan="2" class='title' align="center">과태료</td>
                    <td colspan="2" class='title' align="center">면책금</td>
                    <td colspan="2" class='title' align="center">휴/대차료</td>
                    <td colspan="2" class='title' align="center">중도해지위약금</td>
                    <td colspan="2" class='title' align="center">합계</td>
                </tr>
                <tr align="center"> 
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=4% class='title'>건수</td>
                    <td width=8% class='title'>금액</td>
                    <td width=7% class='title'>건수</td>
                    <td width=11% class='title'>금액</td>
                </tr>
                <tr> 
                    <td class='title'>미수금</td>
                    <td align="right"><%=settle.get("PRE_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("PRE_AMT")))%>원</td>
                    <td align="right"><%=settle.get("FEE_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("FEE_AMT")))%>원</td>
                    <td align="right"><%=settle.get("FINE_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("FINE_AMT")))%>원</td>
                    <td align="right"><%=settle.get("SERV_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("SERV_AMT")))%>원</td>
                    <td align="right"><%=settle.get("ACCID_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("ACCID_AMT")))%>원</td>
                    <td align="right"><%=settle.get("CLS_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("CLS_AMT")))%>원</td>
                    <td align="right"><%=settle.get("TOT_SU")%>건</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("TOT_AMT")))%>원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연체현황</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" class='title' align="center" width=13%>기준일자</td>
                    <td class='title' align="center" rowspan="2" width=20%>총대여료</td>
                    <td colspan="3" class='title' align="center">연체대여료</td>
                    <td width=14% class='title' align="center" rowspan="2">연체점유비</td>
                    <td width=12% class='title' align="center" rowspan="2">전체순위</td>
                </tr>
                <tr align="center"> 
                    <td width=12% class='title'>건수</td>
                    <td width=17% class='title'>금액</td>
                    <td width=12% class='title'>연체율</td>
                </tr>
          <%if(feedps.size() > 0){
		  		//int ranking = 1;
				for (int i = 0 ; i < feedps.size() ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
//System.out.println("feedp.getGubun()="+feedp.getGubun());					
					if(user_id.equals(feedp.getGubun())){
					
						if(feedp.getTot_su4().equals("")){
							dly_per2 = Float.parseFloat(feedp.getTot_amt2())/(float)((tot_dly_amt)*100);
							per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
						}else{
							per2 = feedp.getTot_su4();
						}
		  %>
                <tr align="center"> 
                    <td><%= Util.getDate() %></td>
                    <td><%=Util.parseDecimalLong(feedp.getTot_amt1())%>원</td>
                    <td><%=Util.parseDecimal(feedp.getTot_su2())%>건</td>
                    <td><%=Util.parseDecimal(feedp.getTot_amt2())%>원</td>
                    <td><%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>%</td>
                    <td><%=AddUtil.parseFloatCipher(per2,2)%>%</td>
                    <td><%= i+1 %>위</td>
                </tr>
          <% 		break;
		  			}
		  		//ranking++;
				
		  		}
		  	}else{ %>
                <tr align="center"> 
                    <td colspan="7">해당하는 연체가 없습니다.</td>
                </tr>
          <% } %>
            </table> 
        </td>
    </tr>
    <tr> 
        <td width="100%" align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td align="center">&nbsp;</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

