<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cls.*, acar.fee.*, acar.car_accident.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.arrear.ArrearDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"4":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	//�������� ����Ʈ :���� �Ǵ� �ߵ�
	Vector clss = ad_db.getClsFeeScdList(br_id, gubun1, gubun2, gubun3, "4", gubun5, "", "", s_kd, t_wd, sort_gubun, asc);
	int cls_size = clss.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=cls_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='40%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                  <td width='10%' class='title'>����</td>					
                  <td width='13%' class='title'>����</td>
        		  <td width='25%' class='title'>����ȣ</td>
        		  <td width='29%' class='title'>��ȣ</td>
        		  <td class='title'>������ȣ</td>
        		</tr>
    	    </table>
	    </td>
	    <td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='18%' class='title'>����</td>
                    <td width='12%' class='title'>��������</td>
                    <td width='12%' class='title'>��������</td>			
                    <td width='12%' class='title'>�Աݿ�����</td>
                    <td width='18%' class='title'>�ݾ�</td>
                    <td width='10%' class='title'>��ü����</td>
                    <td width='10%' class='title'>�������</td>
                    <td width='8%' class='title'>����</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(cls_size > 0){%>
    <tr>
	    <td class='line' width='40%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < cls_size ; i++){
    			Hashtable cls = (Hashtable)clss.elementAt(i);
    			//��ü�� ����
    			boolean flag = ac_db.calDelay((String)cls.get("RENT_MNG_ID"), (String)cls.get("RENT_L_CD"));%>
              <tr> 
                <td width='10%' align='center'><%=i+1%></td>
                <td width='13%' align='center'>
                <%if(String.valueOf(cls.get("CLS_GUBUN")).trim().equals("�����")){%>
                <a href="javascript:parent.view_memo('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>','4','','','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=a_cad.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "4", "", "")%>"><font color='red'><%=cls.get("GUBUN")%></font></a>
                <%}else{%>
                <a href="javascript:parent.view_memo2('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','1','<%=cls.get("TM")%>','0','<%=cls.get("BUS_ID2")%>')" onMouseOver="window.status=''; return true" title="<%=af_db.getMaxMemo(String.valueOf(cls.get("RENT_MNG_ID")), String.valueOf(cls.get("RENT_L_CD")), "")%>"><font color='red'><%=cls.get("GUBUN")%></font></a>
                <%}%>            
                </td>
                <td width='25%' align='center'><%=cls.get("RENT_L_CD")%></td>
                <td width='29%' align='center'><span title='<%=cls.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 7)%></a></span></td>
                <td align='center'><span title='<%=cls.get("CAR_NO")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%></span></td>
              </tr>
              <%		}%>
              <tr> 
                <td class="title" align='center'>��Ȳ</td>
    			<td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>
                <td class="title" align='center'>�հ�</td>
                <td class="title">&nbsp;</td>
             
              </tr>
            </table>
	    </td>
	    <td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%		for (int i = 0 ; i < cls_size ; i++){
    			Hashtable cls = (Hashtable)clss.elementAt(i);%>
              <tr> 
                <td width='18%' align='center'><span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 9)%></span></td>
                <td width='12%' align='center'><%=cls.get("CLS_DT")%></td>
                <td width='12%' align='center'><%=cls.get("CLS_GUBUN")%></td>			
                <td width='12%' align='center'><%=cls.get("EST_DT")%></td>
                <td width='18%' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("AMT")))%></td>
                <td width='10%' align='right'><%=cls.get("DLY_DAYS")%>��&nbsp;</td>
                <td width='10%' align='center'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td>
                <td width='8%' align='center'>
                <% if (cls.get("CREDIT_METHOD").equals("1") || cls.get("CREDIT_METHOD").equals("2")) { %>
                 <a href="javascript:parent.view_credit('<%=cls.get("RENT_MNG_ID")%>', '<%=cls.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
                <% } else if ( auth_rw.equals("4") ||  auth_rw.equals("5") ||  auth_rw.equals("6")) {%> 
                <a href="javascript:parent.reg_credit('<%=cls.get("RENT_MNG_ID")%>', '<%=cls.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                <% } %>
                </td>
              </tr>
              <%
    				total_su = total_su + 1;
    				total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("AMT")));
    		  		}%>		  
              <tr> 
                <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>		  
                <td class="title">&nbsp;</td>	
                <td class="title">&nbsp;</td>	  
                <td class="title" style="text-align:right"><%=Util.parseDecimal(total_amt)%></td>
                <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>
                <td class="title">&nbsp;</td>  
              </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
    	<td class='line' width='40%' id='td_con' style='position:relative;'>			
          <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
    		  <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
    		</tr>
    	  </table>
    	</td>
    	<td class='line' width='60%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr>
    		  <td>&nbsp;</td>
    		</tr>
    	  </table>
    	</td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
