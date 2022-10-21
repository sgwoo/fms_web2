<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.cus0403.*" %>
<jsp:useBean id="cnd" scope="session" class="acar.common.ConditionBean"/>
<jsp:useBean id="c43_scBn" class="acar.cus0403.Cus0403_scBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	Cus0403_Database c43_db = Cus0403_Database.getInstance();

//	System.out.println(cnd.setGubun2()+","+cnd.setGubun3()+","+cnd.getS_kd()+","+cnd.getT_wd());	

	Cus0403_scBean[] c43_scBns = c43_db.getCarList(cnd);

	CommonDataBase c_db = CommonDataBase.getInstance();	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
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
	function init()
	{		
		setupEvents();
	}
//-->
</script>
</head>

<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width=1209>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width=1209>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='tr_title' style='position:relative;z-index:1'>		                        
                    <td width=45% class='line' id='td_title' style='position:relative;'> 
                        <table width="100%" height="43" border="0" cellpadding="0" cellspacing="1">
                            <tr> 
                                <td width='6%' class='title' style='height:45'>����</td>
                                <td width='19%' class='title'>����ȣ</td>
                                <td width='25%' class='title'>��ȣ</td>
                                <td width='17%' class='title'>������ȣ</td>
                                <td width='33%' class='title'>����</td>
                            </tr>
                        </table>
                    </td>		
                    <td width=55% class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td colspan="2" class='title'>����˻�(��ȿ�Ⱓ)</td>
                                <td width='11%' rowspan="2" class='title'>�����˻���</td>
                                <td width='11%' rowspan="2" class='title'>����Ÿ�(km)</td>
                                <td width='11%' rowspan="2" class='title'>���ʵ����</td>
                                <td width='12%' rowspan="2" class='title'>��������</td>
                                <td width='12%' rowspan="2" class='title'>��ุ����</td>
                                <td width='9%' rowspan="2" class='title'>������</td>
                                <td width='12%' rowspan="2" class='title'>���������</td>
                            </tr>
                            <tr> 
                                <td class='title' width="11%">������</td>
                                <td class='title' width="11%">������</td>
                            </tr>
                        </table>
             		</td>
            	</tr>
<%if(c43_scBns.length !=0 ){%>
	            <tr>
            
                    <td class='line' id='td_con' style='position:relative;' width=45%> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
              <% for(int i=0; i< c43_scBns.length; i++){
		c43_scBn = c43_scBns[i];
	%>
                            <tr> 
                                <td width='6%' align='center'><%=i+1%></td>
                                <td width='19%' align='center'><%=c43_scBn.getRent_l_cd()%></td>
                                <td width='25%' align='left'><span title='<%=c43_scBn.getFirm_nm()%>'>&nbsp; 
                                  <%=AddUtil.subData(c43_scBn.getFirm_nm(),9)%></span></td>
                                <td width='17%' align='center'><a href="javascript:parent.view_detail('<%=c43_scBn.getCar_mng_id()%>','<%=c43_scBn.getRent_mng_id()%>','<%=c43_scBn.getRent_l_cd()%>','<%=c43_scBn.getClient_id()%>')"><%=c43_scBn.getCar_no()%></a></td>
                                <td width='33%'><span title='<%=c43_scBn.getCar_jnm()+" "+c43_scBn.getCar_nm()%>'>&nbsp;<%=AddUtil.subData(c43_scBn.getCar_jnm()+" "+c43_scBn.getCar_nm(),11)%></span></td>
                            </tr>
                          <%}%>
                            <tr> 
                                <td  class='title' width='6%' align='center'>&nbsp;</td>
                                <td  class='title' width='19%' align='center'>&nbsp;</td>
                                <td  class='title' width='25%' align='center'>&nbsp;</td>
                                <td  class='title' width='17%' align='center'>&nbsp;</td>
                                <td  class='title' width='33%' align='center'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td class='line' width=55%> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
              <% for(int i=0; i< c43_scBns.length; i++){
			c43_scBn = c43_scBns[i];			
	%>
                            <tr> 
                                <td width='11%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getMaint_st_dt())%></td>
                                <td width='11%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getMaint_end_dt())%></td>
                				<td width='11%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getChe_dt())%></td>
                                <td width='11%' align='right' ><%=AddUtil.parseDecimal(c43_scBn.getTot_dist())%>&nbsp;&nbsp;&nbsp;</td>
                                <td width='11%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getInit_reg_dt())%></td>
                                <td width='12%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getRent_start_dt())%></td>
                                <td width='12%' align='center' ><%=AddUtil.ChangeDate2(c43_scBn.getRent_end_dt())%></td>
                                <td width='9%' align='center' ><%=c43_scBn.getBrch_id()%></td>
                                <td width='12%' align='center' ><%=c_db.getNameById(c43_scBn.getMng_id(), "USER")%></td>
                            </tr>
                          <%}%>
                            <tr> 
                                <td width='11%' align='center'  class='title'>&nbsp;</td>
                                <td width='11%' align='center'  class='title'>&nbsp;</td>
                				<td width='11%' align='center'  class='title'>&nbsp;</td>
                                <td width='11%' align='center'  class='title'>&nbsp;</td>
                                <td width='11%' align='center'  class='title'>&nbsp;</td>
                                <td class='title' width='12%' align='center'>&nbsp;</td>
                                <td class='title' width='12%' align='center'>&nbsp;</td>
                                <td class='title' width='9%' align='center'>&nbsp;</td>
                                <td class='title' width='12%' align='center'>&nbsp;</td>
                            </tr>
                        </table>
		            </td>
	            </tr>
<%}else{%>
	            <tr>	        
                    <td class='line' id='td_con' style='position:relative;' width=45%> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=55%> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td align='left' colspan="9">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ش������� 
                                  �����ϴ�.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>
