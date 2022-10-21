<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*, acar.res_search.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//��������
	Hashtable res = rs_db.getCarInfo(car_mng_id);
	
	//�縮��������Ȳ
	Vector srh = shDb.getShResHList(car_mng_id);
	int srh_size = srh.size();
	
	//�����������Ȳ
	Vector conts = rs_db.getResCarList(car_mng_id);
	int cont_size = conts.size();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>[<%=res.get("CAR_NO")%>] �������� �̷�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="5%">����</td>				
                    <td class="title" width="10%">�����</td>
                    <td class="title" width="10%">�����Ȳ</td>					
                    <td class="title" width="20%">����Ⱓ</td>					
                    <td class="title" width="45%">�޸�</td>
                    <td class="title" width="10%">�����</td>					
                </tr>
				<%	
					for(int i = 0 ; i < srh_size ; i++){
						Hashtable sr_ht = (Hashtable)srh.elementAt(i);
						%>
                <tr> 
                    <td align="center"><%=i+1%></td>				
                    <td align="center"><%=c_db.getNameById(String.valueOf(sr_ht.get("DAMDANG_ID")),"USER")%></td>
                    <td align="center"><%	if(String.valueOf(sr_ht.get("SITUATION")).equals("0"))			out.print("�����");
        									else if(String.valueOf(sr_ht.get("SITUATION")).equals("2"))	out.print("���Ȯ��");  %></td>
                    <td align="center">
					<%if(String.valueOf(sr_ht.get("RES_ST_DT")).equals("")){%>
					���<%//= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %>
					<%}else{%>
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_ST_DT"))) %>~<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("RES_END_DT"))) %>
					<%}%>
					</td>
                    <td>&nbsp;<%=sr_ht.get("MEMO")%></td>
                    <td align="center">
					<%= AddUtil.ChangeDate2(String.valueOf(sr_ht.get("REG_DT"))) %>
					</td>					
                </tr>
				<%}%>
            </table>
	    </td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������������Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="5%">����</td>
                    <td class=title width="8%">�����</td>					
                    <td class=title width="8%">����</td>
                    <td class=title width="6%">����</td>
                    <td class=title width="33%">�뿩�Ⱓ</td>
                    <td class=title width="20%">��ȣ</td>
                    <td class=title width="10%">�����</td>
                    <td class=title width="10%">�������</td>
                </tr>
              <%	if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable reservs = (Hashtable)conts.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=reservs.get("BUS_NM")%></td>					
                    <td align="center"><span title='<%=reservs.get("RENT_S_CD")%>'><%=reservs.get("RENT_ST")%></span></td>
                    <td align="center"><%=reservs.get("USE_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_START_DT")))%> ~ <%=AddUtil.ChangeDate3(String.valueOf(reservs.get("RENT_END_DT")))%></td>
                    <td align="center"><%=reservs.get("FIRM_NM")%></td>
                    <td align="center"><%=reservs.get("CUST_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(reservs.get("REG_DT")))%></td>
                </tr>
              <%		}
      			}else{%>
                <tr> 
                    <td colspan='8' align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>
    <tr>  
        <td align="right" colspan=2><a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
