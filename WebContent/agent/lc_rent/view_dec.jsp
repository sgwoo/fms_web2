<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	//거채처 최근 계약 정보
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	ClientBean client = al_db.getNewClient(client_id);
	
	//고객신용평가 이력리스트
	Vector vt  = a_db.getDecClientHList(client_id);
	int vt_size = vt.size();
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//신용평가 보기
	function view_eval(rent_mng_id, rent_l_cd){
		var fm = document.form1;
		window.open("/agent/lc_rent/view_eval.jsp?client_id="+fm.client_id.value+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd, "VIEW_EVAL", "left=50, top=50, width=850, height=600");
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<p>
<form name='form1' action='search_eval.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>	
    <tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='10%'>구분</td>
                    <td width='20%'>&nbsp;<%if(client.getClient_st().equals("1")) 		out.println("법인");
                  	else if(client.getClient_st().equals("2"))  out.println("개인");
                  	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                  	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                  	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%></td>
                    <td class='title' width='10%'>상호/성명</td>
                    <td>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td>&nbsp;</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="5%" rowspan="2" class=title>연번</td>
                    <td width="20%" rowspan="2" class=title>신용등급</td>
                    <td width="10%" rowspan="2" class='title'>심사담당자</td>
                    <td width="10%" rowspan="2" class='title'>판정일자</td>
                    <td class='title' colspan="4">계약</td>
                </tr> 
                <tr>
                    <td width="10%" class=title>계약일자</td>
                    <td width="10%" class=title>차량번호</td>
                    <td class='title'>차명</td>
                    <td width="10%" class='title'>최초영업자</td>			
                </tr>         		          
                <%if(vt_size > 0){
    		  		for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String dec_gr = String.valueOf(ht.get("DEC_GR"));%>	
                <tr>
                    <td class=title><%=i+1%></td>
                    <td align="center">
        			  <% if(dec_gr.equals("3")) out.print("신설법인"); 	%>
                      <% if(dec_gr.equals("0")) out.print("일반고객"); 	%>
                      <% if(dec_gr.equals("1")) out.print("우량기업"); 	%>
                      <% if(dec_gr.equals("2")) out.print("초우량기업");  %></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(ht.get("DEC_F_ID")),"USER")%></td>
                    <td align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DEC_F_DT")))%></td>
                    <td align="center" colspan="4">
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
        			  <%	//고객신용평가 계약리스트
        					Vector vt2  = a_db.getDecContHList(client_id, dec_gr, String.valueOf(ht.get("DEC_F_DT")));
        					int vt_size2 = vt2.size();
        					for(int j = 0 ; j < vt_size2 ; j++){
        						Hashtable ht2 = (Hashtable)vt2.elementAt(j);%>
                            <tr>
                                <td align="center" width="18%"><%=AddUtil.ChangeDate2(String.valueOf(ht2.get("RENT_DT")))%></td>
                                <td align="center" width="18%"><a href="javascript:view_eval('<%=ht2.get("RENT_MNG_ID")%>','<%=ht2.get("RENT_L_CD")%>')"><%=ht2.get("CAR_NO")%></a></td>
                                <td align="center" ><%=ht2.get("CAR_NM")%></td>			
                        	    <td align="center" width="18%"><%=c_db.getNameById(String.valueOf(ht2.get("BUS_ID")),"USER")%></td>				  	  
                            </tr> 
        				<%}%>
        			    </table>	
        			</td>
                </tr>
    		  <%}}%>
            </table>
        </td>
	<tr>
	    <td colspan=4>&nbsp;</td>
	</tr>
	<tr>
	    <td colspan=4 align='right'><a href='javascript:set_eval()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a> &nbsp;&nbsp;<a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
	</tr>
</table>
</body>
</html>