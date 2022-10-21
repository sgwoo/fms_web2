<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_ins.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function GetInsCom(ins_com_id, ins_com_nm, car_rate, ins_rate, ext_date, agnt_tel, agnt_fax, agnt_imgn_tel, acc_tel, zip, addr, ins_com_f_nm, zip1, addr1){
		var fm = parent.c_foot.document.form1;
		fm.ins_com_id.value 	= ins_com_id;
		fm.ins_com_nm.value 	= ins_com_nm;
		fm.car_rate.value 	= car_rate;
		fm.ins_rate.value 	= ins_rate;
		fm.ext_date.value 	= ext_date;
		fm.agnt_tel.value 	= agnt_tel;
		fm.agnt_fax.value 	= agnt_fax;
		fm.agnt_imgn_tel.value 	= agnt_imgn_tel;
		fm.acc_tel.value 	= acc_tel;
		fm.t_zip.value 		= zip;
		fm.t_addr.value		= addr;
		fm.ins_com_f_nm.value 	= ins_com_f_nm;
		fm.t_zip1.value 		= zip1;
		fm.t_addr1.value		= addr1;
	}
//-->
</script>

</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	Vector inss = ai_db.getInsComList();
	int ins_size = inss.size();
%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>보험사 관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>       
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>					
                    <td class='line' width="100%"> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                              	<td class=title width=5%>연번</td>
                                <td class=title width=8%>보험사ID</td>
                                <td class=title width=17%>보험사명</td>
                                <td class=title width=10%>가입경력율</td>
                                <td class=title width=10%>보험율</td>
                                <td class=title width=10%>할인할증율</td>
                                <td class=title width=10%>전화번호</td>
                                <td class=title width=10%>FAX</td>
                                <td class=title width=10%>긴급출동번호</td>
                                <td class=title width=10%>사고접수번호</td>
                            </tr>
                  <%if(ins_size > 0){
    					for(int i = 0 ; i < ins_size ; i++){
    						Hashtable ins = (Hashtable)inss.elementAt(i);%>
                            <tr> 
                              	<td align="center"><%= i+1%></td>
                                <td align="center"><a href="javascript:GetInsCom('<%=ins.get("INS_COM_ID")%>','<%=ins.get("INS_COM_NM")%>','<%=ins.get("CAR_RATE")%>','<%=ins.get("INS_RATE")%>','<%=ins.get("EXT_DATE")%>','<%=ins.get("AGNT_TEL")%>','<%=ins.get("AGNT_FAX")%>','<%=ins.get("AGNT_IMGN_TEL")%>','<%=ins.get("ACC_TEL")%>','<%=ins.get("ZIP")%>','<%=ins.get("ADDR")%>','<%=ins.get("INS_COM_F_NM")%>','<%=ins.get("ZIP1")%>','<%=ins.get("ADDR1")%>')" onMouseOver="window.status=''; return true"><%=ins.get("INS_COM_ID")%></a></td>
                                <td align="center"><%=ins.get("INS_COM_NM")%></td>
                                <td align="center"><%=ins.get("CAR_RATE")%></td>
                                <td align="center"><%=ins.get("INS_RATE")%></td>
                                <td align="center"><%=ins.get("EXT_DATE")%></td>
                                <td align="center"><%=ins.get("AGNT_TEL")%></td>
                                <td align="center"><%=ins.get("AGNT_FAX")%></td>
                                <td align="center"><%=ins.get("AGNT_IMGN_TEL")%></td>
                                <td align="center"><%=ins.get("ACC_TEL")%></td>
                            </tr>
                  <%	}
    				}else{%>
                            <tr align="center"> 
                                <td colspan="10">등록된 자료가 없습니다.</td>
                            </tr>
                  <%}%>
                        </table>
    		        </td>    		
    		    </tr>
    	    </table>
	    </td>
    </tr>	
</table>
</body>
</html>