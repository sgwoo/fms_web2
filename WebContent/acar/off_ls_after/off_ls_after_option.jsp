<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_after.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	
	
	Offls_afterDatabase olfD = Offls_afterDatabase.getInstance();
	Vector mOptionList = olfD.getMoption_lst();
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
-->
</script>
</head>
<body onLoad="javascript:init()">
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<table border=0 cellspacing=0 cellpadding=0 width="1200">
    <tr>
        <td>
<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr id='tr_title' style='position:relative;z-index:1'>		
            <td class='line' id='td_title' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td width='40' class='title'>����</td>
                  <td width="90" class='title'>������ȣ</td>
                  <td width="140" class='title'>����</td>
                  <td width='140' class='title'>��ȣ</td>
                </tr>
              </table></td>		
            <td class='line'>
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td width='90' class='title'>������</td>
                  <td width='50' class='title'>����</td> 
                  <td width='110' class='title'>Ư�Ҽ�</td> 				  
                  <td width='90' class='title'>�����</td>
                  <td width='90' class='title'>�ŸŰ�</td>
                  <td width='90' class='title'>�Ÿ�����</td>
                  <td width='90' class='title'>���ʵ����</td>
                  <td width='100' class='title'>�Һ��ڰ���(��)</td>
				  <td width='100' class='title'>���԰���(��)</td>
                </tr>
                <tr> </tr>
              </table>
            </td>
	</tr>
<%if(mOptionList.size() > 0 ){%>
	<tr>
            <td class='line' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< mOptionList.size(); i++){
					Hashtable car = (Hashtable)mOptionList.elementAt(i); %>
                <tr> 
                  <td width='40' align='center'><%=i+1%></td>
                  <td width='90' align='center'><a href="javascript:parent.view_detail('<%=auth_rw%>','<%=car.get("CAR_MNG_ID")%>','')"><%=car.get("CAR_NO")%></a></td>
                  <td width='140' align='left'>&nbsp;<span title='<%=car.get("CAR_NAME")%>'><%=AddUtil.subData((String)car.get("CAR_NAME"),10)%></span></td>
                  <td width='140' align='left'>&nbsp;<span title='<%=car.get("FIRM_NM")%>'><%=AddUtil.subData((String)car.get("FIRM_NM"),7)%></span></td>
                </tr>
                <%}%>
                <tr> 
                  <td  class='title' align='center'>&nbsp;</td>
                  <td  class='title' align='center'>&nbsp;</td>
                  <td  class='title' align='center'>&nbsp;</td>
                  <td  class='title' align='center'>&nbsp;</td>
                </tr>
              </table></td>
            <td class='line'>
              <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< mOptionList.size(); i++){
					Hashtable car = (Hashtable)mOptionList.elementAt(i); %>
                <tr> 
                  <td width='90' align='center'><%=AddUtil.ChangeDate2((String)car.get("CLS_DT"))%></td>
                  <td width='50' align='center'><span title="<% if(!((String)car.get("REQ_DT")).equals("")) out.print(AddUtil.ChangeDate2((String)car.get("REQ_DT"))); %>"><% if(((String)car.get("REQ_DT")).equals("")) out.print("<font color=red>��û��</font>"); else out.print("û��"); %></span></td>
                  <td width='110' align='center'>
				  <% if(((String)car.get("TAX_ST")).equals("1")){ %>
						<font color="#9900CC">����(���뿩)</font>
					<% }else if(((String)car.get("TAX_ST")).equals("2")){
							if(((String)car.get("CLS_MAN_ST")).equals("0")||((String)car.get("CLS_MAN_ST")).equals("1")){%>
								<font color="#9900CC">����(�Ű�)</font>					
							<%}else{%>
								<font color="#3300CC">����</font>					
							<%}
					}else{%>
						-
					<%}%></td>				  				  
                  <td width='90' align='center'><span title='<%=car.get("SUI_NM")%>'> <%=AddUtil.subData((String)car.get("SUI_NM"),5)%></span></td>
                  <td width='90' align='right'><%=AddUtil.parseDecimal(car.get("MM_PR"))%>&nbsp;&nbsp;</td>
                  <td width='90' align='center'><%=AddUtil.ChangeDate2((String)car.get("CONT_DT"))%></td>
                  <td width='90' align='center'><%=AddUtil.ChangeDate2((String)car.get("INIT_REG_DT"))%></td>
                  <td width='100' align='right'><%=AddUtil.parseDecimal(car.get("C_AMT"))%>&nbsp;&nbsp;</td>
				  <td width='100' align='right'><%=AddUtil.parseDecimal(car.get("F_AMT"))%>&nbsp;&nbsp;</td>
                </tr>
                <%}%>
                <tr> 
                  <td  class='title' width='90' align='center' >&nbsp;</td>
                  <td  class='title' width='50' align='center' >&nbsp;</td>
                  <td  class='title' width='110' align='center' >&nbsp;</td>				  				  
                  <td  class='title' width='90' align='center' >&nbsp;</td>				  
                  <td  class='title' width='90' align='center' >&nbsp;</td>
                  <td  class='title' width='90' align='center'>&nbsp;</td>
                  <td  class='title' width='90' align='right'>&nbsp;&nbsp;&nbsp;</td>
                  <td  class='title' width='100' align='right'>&nbsp;&nbsp;&nbsp;</td>
				  <td  class='title' width='100' align='right'>&nbsp;&nbsp;&nbsp;</td>
                </tr>
              </table>
            </td>
	</tr>
<%}else{%>
	<tr>
	        <td class='line' id='td_con' style='position:relative;'> <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <tr> 
                  <td align='center'></td>
                </tr>
              </table></td>
	<td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
          <tr> 
                  <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ش� ������ �����ϴ�.</td>
          </tr>          
        </table>
		</td>
	</tr>
<%}%>		
</table>
 </td>
    </tr>
</table>
</form>
</body>
</html>