<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_user_id 	= request.getParameter("card_user_id")==null?"":request.getParameter("card_user_id");

	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//�������
	user_bean = umd.getUsersBean(card_user_id);
	
	DeptBean dept_r [] = umd.getDeptAll();
	BranchBean br_r [] = umd.getBranchAll();
	
	Vector vts = CardDb.getCardUserHList(card_user_id);
	int vt_size = vts.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//ī�峻�뺸��
	function CardMngUpd(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_u.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}
	//ī�����ó���ϱ�
	function CardMngDel(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_d.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='cardno' value=''>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                  <td width='15%'  class='title'>����</td>
                  <td>&nbsp;
    			    <input type="text" name="br_nm" value="<%=user_bean.getBr_nm()%>" size="30" class=whitetext redeonly>
                  </td>
                </tr>
                <tr>
                    <td class='title'>�μ�</td>
                    <td>&nbsp; 
        			  <input type="text" name="dept_nm" value="<%=user_bean.getDept_nm()%>" size="30" class=whitetext redeonly>
                    </td>
                </tr>			
                <tr>
                    <td class='title'>�̸�</td>
                    <td>&nbsp;
			        <input type="text" name="user_nm" value="<%=user_bean.getUser_nm()%>" size="30" class=whitetext redeonly></td>
                </tr>
                <tr>
                    <td class='title'>�Ի�����</td>
                    <td>&nbsp;
			        <input type="text" name="enter_dt" value="<%=AddUtil.ChangeDate2(user_bean.getEnter_dt())%>" size="30" class=whitetext  redeonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
         </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>		  
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>����</td>
                    <td width='15%' class='title'>�뵵����</td>
                    <td width='10%' class='title'>ī������</td>
                    <td width='20%' class='title'>ī���ȣ</td>
                    <td width='20%' class='title'>ī���̸�</td>
                    <td width='15%' class='title'>ī��������</td>
                    <td width='15%' class='title'>ī��ȸ����</td>
                </tr>
		  <%if(vt_size > 0){%>
          <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("CARD_ST_NM")%></td>
                    <td align="center"><%=ht.get("CARD_KIND")%></td>
                    <td align="center"><%=ht.get("CARDNO")%></td>
                    <td align="center"><%=ht.get("CARD_NAME")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <%	}%>		  
                  <%}else{%>	
                <tr align="center">
                    <td colspan="8">��ϵ� ����Ÿ�� �����ϴ�.</td>
                    </tr>		  
                <%}%>		  		  	  		  
            </table>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
