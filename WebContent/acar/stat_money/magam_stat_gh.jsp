<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	
	//금액 가져오기
	Vector accs = ac_db.getStatFeeDebtGap(save_dt);
	int acc_size = accs.size();
	
	//최고값 가져오기
	Hashtable macc = ac_db.getStatFeeDebtGapMax(save_dt);
	
	String while_day = String.valueOf(acc_size);//표시건수
	String f_all = "";
	String a_all = "";
	String d_all = "";
	String fee_amt = "";
	String alt_amt = "";
	String dly_amt = "";
	
	String m_fee_amt = String.valueOf(macc.get("FEE_AMT"));
	String m_alt_amt = String.valueOf(macc.get("ALT_AMT"));
	String m_dly_amt = String.valueOf(macc.get("DLY_AMT"));
	String heigh_max = "";
	
	if(AddUtil.parseLong(m_fee_amt) > AddUtil.parseLong(m_alt_amt))	heigh_max = AddUtil.million(m_fee_amt);
	else															heigh_max = AddUtil.million(m_alt_amt);
	long iheigh_max = AddUtil.parseLong(heigh_max)+50;
	
	//데이타 가공하기
	for (int i = 0 ; i < acc_size ; i++){
		Hashtable acc = (Hashtable)accs.elementAt(i);
		float per = AddUtil.parseFloat(String.valueOf(acc.get("G_ALT_AMT")))/AddUtil.parseFloat(String.valueOf(acc.get("FEE_S_AMT")))*100;
		fee_amt = AddUtil.million(String.valueOf(acc.get("FEE_S_AMT")));
		alt_amt = AddUtil.million(String.valueOf(acc.get("G_ALT_AMT")));
		dly_amt = AddUtil.million(String.valueOf(acc.get("DLY_AMT")));
		if(fee_amt.equals("")) fee_amt = "0";
		if(alt_amt.equals("")) alt_amt = "0";
		if(dly_amt.equals("")) dly_amt = "0";
		if(i+1 == acc_size){
			f_all = f_all + fee_amt;
			a_all = a_all + alt_amt;
			d_all = d_all + dly_amt;
		}else{
			f_all = f_all + fee_amt + '/';
			a_all = a_all + alt_amt + '/';
			d_all = d_all + dly_amt + '/';
		}
		
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<!--<link rel=stylesheet type="text/css" href="../../include/table.css">-->
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<form action="" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 재무분석 > 대여료/할부금GAP > <span class=style5>대여료/할부금 그래프</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td>&nbsp;</td>
                    <td>[단위:백만]</td>
                    <td>&nbsp;</td>
                </tr>
                <tr> 
                    <td width="100" rowspan="2">&nbsp;</td>
                    <td rowspan="2"> <applet codebase="http://fms2.amazoncar.co.kr/applet" code="StatGapGraphic.class" width=750 height=400>
                        <param name="height" value="400">
                        <param name="width" value="750">
                        <param name="from_day" value="<%=st_dt%>">
                        <param name="while_day" value="<%=while_day%>">
                        <param name="heigh_max" value="<%=iheigh_max%>">
                        <param name="all" value="<%=f_all%>">
                        <param name="succ" value="<%=a_all%>">
                        <PARAM name="wait" value="<%=d_all%>">
                        <PARAM name="month" value="true">
                        <!--월단위-->
                      </applet> </td>
                    <td> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                            <tr align="center"> 
                                <td> 
                                <hr width="30" size="5" color="#3366CC">
                                </td>
                                <td height="30"><font color="#3366CC"><b>대여료</b></font>&nbsp;&nbsp;</td>
                            </tr>
                            <tr align="center"> 
                                <td> 
                                <hr width="30" size="5" color="#006600">
                                </td>
                                <td height="30"><font color="#006600"><b>할부금</b></font>&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100" valign="bottom">[년월]<br>
                      <br>
                      <br>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">(단위:백만원, 할부금:리스료 포함)</td>
    </tr>		
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              <% 	int line = acc_size / 12;
    				if(acc_size%12 >0)	line = line + 1;
    				for(int j = 0 ; j < line ; j++){%>
              <tr align="center" valign="middle"> 
                <td class=title>년월</td>
                <%		for (int i = 12*j ; i < 12*(j+1) ; i++){%>
                <%			if(acc_size > i){
    							Hashtable acc = (Hashtable)accs.elementAt(i);%>
                <td class=title><%=AddUtil.ChangeDate2(String.valueOf(acc.get("SEQ")))%></td>
                <%			}else{%>
                <td></td>
                <%			}%>
                <%		}%>
              </tr>
              <tr align="center" valign="middle"> 
                <td class=title>대여료</td>
                <%		for (int i = 12*j ; i < 12*(j+1) ; i++){%>
                <%			if(acc_size > i){
    							Hashtable acc = (Hashtable)accs.elementAt(i);%>
                <td align="right"><%=AddUtil.million(String.valueOf(acc.get("FEE_S_AMT")))%></td>
                <%			}else{%>
                <td></td>
                <%			}%>
                <%		}%>
              </tr>
              <tr align="center" valign="middle"> 
                <td class=title>할부금</td>
                <%		for (int i = 12*j ; i < 12*(j+1) ; i++){%>
                <%			if(acc_size > i){
    							Hashtable acc = (Hashtable)accs.elementAt(i);%>
                <td align="right"><%=AddUtil.million(String.valueOf(acc.get("G_ALT_AMT")))%></td>
                <%			}else{%>
                <td></td>
                <%			}%>
                <%		}%>
              </tr>
              <%	}%>
            </table>
        </td>
    </tr>
</table>		
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
