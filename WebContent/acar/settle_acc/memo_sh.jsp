<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="acar.common.*, java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.client.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�⺻����
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	ContBaseBean base = a_db.getContBase(m_id, l_cd);				//������
	ClientBean client = l_db.getClient(base.getClient_id());	//������
%>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>����ȣ</td>
                    <td>&nbsp;<%=fee.get("RENT_L_CD")%></td>
                    <td class='title'>��ȣ</td>
                    <td>&nbsp;<%=fee.get("FIRM_NM")%></td>
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=fee.get("CAR_NO")%></td>
                    <td class='title'>�����</td>
                    <td>&nbsp;<%=c_db.getNameById((String)fee.get("BUS_ID2"), "USER")%></td>
                </tr>
                <tr> 
                    <td class='title'>�繫��</td>
                    <td>&nbsp;<%= client.getO_tel()%></td>
                    <td class='title'>�޴���</td>
                    <td>&nbsp;<%= client.getM_tel()%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%= client.getH_tel()%></td>
                    <td class='title'>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>		
            </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr>		
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ְ������</span>
		&nbsp;&nbsp;<a href="http://www.koreapost.go.kr/woopuns/domestic01_post1_6.jsp" target='_blank'><img src=/acar/images/center/button_dgbd.gif align=absmiddle border=0></a>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='17%' class='title'>������ȣ</td>
        		    <td width='15%' class='title'>��������</td>
        		    <td width='40%' class='title'>����</td>					
                    <td width='14%' class='title'>�����Ⱓ</td>
                    <td width='10%' class='title'>��ĵ</td>	
                    <td width='4%' class='title'>&nbsp;</td>	  
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>
    <tr>
	    <td colspan='2'>
	    <iframe src="/fms2/con_fee/fee_memo_sh_in_settle.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>" name="i_no" width="100%" height="70" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
    <tr>		
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>CMS ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
                    <td width='10%' class='title'>�ۼ���</td>
        		    <td width='11%' class='title'>�ۼ���</td>
        		    <td width='11%' class='title'>�����</td>					
                    <td width='68%' class='title'>�޸�</td>					
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>
    <tr>
	    <td colspan='2'>
	    <iframe src="/fms2/con_fee/fee_memo_sh_cms_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&fee_tm=<%=fee_tm%>&tm_st1=<%=tm_st1%>" name="i_no" width="100%" height="110" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
        <tr>
        <td></td>
    </tr>
    <tr>		
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>��ȭ����</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>					
        		    <td width='10%' class='title'>�ۼ���</td>
                    <td width='12%' class='title'>����</td>
                    <td width='10%' class='title'>�ۼ���</td>
        		    <td width='10%' class='title'>�����</td>					
                    <td width='58%' class='title'>�޸�</td>					
		        </tr>
	        </table>
	    </td>
	    <td width='17'>&nbsp;</td>
    </tr>
    <tr>
	    <td colspan='2'>
	    <iframe src="memo_sh_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>" name="i_no" width="100%" height="250" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=no, marginwidth=0, marginheight=0 >
	    </iframe>
	    </td>
    </tr>
</table>
</body>
</html>
