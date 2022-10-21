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
	
	//�̼������� ���
	Hashtable settle = s_db.getSettleListStat("", "", "", "", "", "", "8", user_id);
	
	//��ü ��ü
	Vector feedps3 = ac_db.getFeeStat_Dlyper(br_id, "", "", "");
	if(feedps3.size() > 0){
		for (int i = 0 ; i < feedps3.size() ; i++){
			IncomingSBean feedp = (IncomingSBean)feedps3.elementAt(i);
			tot_dly_amt = Long.parseLong(feedp.getTot_amt2());
		}
	}
	
	//��ü��
	Vector feedps = ad_db.getDlyBusStat(br_id, "0002", "");
	//��ü�� �μ�����
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̼���Ȳ</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=10% class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">������</td>
                    <td colspan="2" class='title' align="center">�뿩��</td>
                    <td colspan="2" class='title' align="center">���·�</td>
                    <td colspan="2" class='title' align="center">��å��</td>
                    <td colspan="2" class='title' align="center">��/������</td>
                    <td colspan="2" class='title' align="center">�ߵ����������</td>
                    <td colspan="2" class='title' align="center">�հ�</td>
                </tr>
                <tr align="center"> 
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=4% class='title'>�Ǽ�</td>
                    <td width=8% class='title'>�ݾ�</td>
                    <td width=7% class='title'>�Ǽ�</td>
                    <td width=11% class='title'>�ݾ�</td>
                </tr>
                <tr> 
                    <td class='title'>�̼���</td>
                    <td align="right"><%=settle.get("PRE_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("PRE_AMT")))%>��</td>
                    <td align="right"><%=settle.get("FEE_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("FEE_AMT")))%>��</td>
                    <td align="right"><%=settle.get("FINE_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("FINE_AMT")))%>��</td>
                    <td align="right"><%=settle.get("SERV_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("SERV_AMT")))%>��</td>
                    <td align="right"><%=settle.get("ACCID_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("ACCID_AMT")))%>��</td>
                    <td align="right"><%=settle.get("CLS_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("CLS_AMT")))%>��</td>
                    <td align="right"><%=settle.get("TOT_SU")%>��</td>
                    <td align="right"><%=Util.parseDecimal(String.valueOf(settle.get("TOT_AMT")))%>��</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ü��Ȳ</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" class='title' align="center" width=13%>��������</td>
                    <td class='title' align="center" rowspan="2" width=20%>�Ѵ뿩��</td>
                    <td colspan="3" class='title' align="center">��ü�뿩��</td>
                    <td width=14% class='title' align="center" rowspan="2">��ü������</td>
                    <td width=12% class='title' align="center" rowspan="2">��ü����</td>
                </tr>
                <tr align="center"> 
                    <td width=12% class='title'>�Ǽ�</td>
                    <td width=17% class='title'>�ݾ�</td>
                    <td width=12% class='title'>��ü��</td>
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
                    <td><%=Util.parseDecimalLong(feedp.getTot_amt1())%>��</td>
                    <td><%=Util.parseDecimal(feedp.getTot_su2())%>��</td>
                    <td><%=Util.parseDecimal(feedp.getTot_amt2())%>��</td>
                    <td><%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>%</td>
                    <td><%=AddUtil.parseFloatCipher(per2,2)%>%</td>
                    <td><%= i+1 %>��</td>
                </tr>
          <% 		break;
		  			}
		  		//ranking++;
				
		  		}
		  	}else{ %>
                <tr align="center"> 
                    <td colspan="7">�ش��ϴ� ��ü�� �����ϴ�.</td>
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

