<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.attend.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	Hashtable ht = new Hashtable();
	Hashtable ht2  = new Hashtable();
	Hashtable ht3   = new Hashtable();
	int b_su = 0; //���Ĺ���-�������� = 2 �̻��ΰ��
		
	Vector vt =  new Vector();

	ht = v_db.getVacation(user_id);
   
	vt = v_db.getVacationList(user_id, (String)ht.get("YEAR"));
	
	ht2 = v_db.getVacationBan(user_id); //�������� ��Ȳ
	ht3 = v_db.getVacationBan2(user_id);  //���� ���� ��Ȳ
	
	b_su =   AddUtil.parseInt((String)ht3.get("B2")) - AddUtil.parseInt((String)ht3.get("B1"));
	b_su= Math.abs(b_su);
		
	String use_dt ="";		
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
//�˾������� ����
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

//-->	
</script>
</head>
<script language="JavaScript">
//����Ÿ ����
function sch_d(sch_id, sch_year, sch_mon, sch_day, seq){
	
	var fm = document.form1;
	
	fm.sch_id.value 	= sch_id;
	fm.start_year.value 	= sch_year;
	fm.start_mon.value 	= sch_mon;
	fm.start_day.value 	= sch_day;
	fm.seq.value 	= seq;
	
	if(confirm('�����Ͻðڽ��ϱ�?')){				
		fm.action='sch_d_a.jsp';					
		fm.target = 'i_no';
		fm.submit();
	}	
			
}
</script>

<body> 
<form name="form1" method='post'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="sch_id" >
<input type="hidden" name="start_year" >
<input type="hidden" name="start_mon" >
<input type="hidden" name="start_day" >
<input type="hidden" name="seq" >

<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5>��������</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  <% if(auth_rw.equals("6")){ %>
    <tr> 
        <td align="right">
			<a href="./vacation_all_new.jsp?auth_rw=<%= auth_rw %>&user_id=<%= user_id %>"><img src=../images/center/button_see_all.gif border=0 align=absmiddle></a>
		</td>
    </tr>
  <% } %>
  
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=8% rowspan="3" class="title">�ٹ���</td>
                    <td width=8% rowspan="3" class="title">�μ�</td>
                    <td width=6% rowspan="3" class="title">����</td>
                    <td width=8% rowspan="3" class="title">����</td>
                    <td width=8% rowspan="3" class="title">�Ի���</td>                 
                    <td colspan="3" class="title">��ӱٹ��Ⱓ</td>
                    <td colspan="4" class="title" width=20% >�ٷα��ع� ����</td>
                    <td colspan="4" class="title" width=20% >��Ա��� {�̿�(���� 30�� ����)}</td>	
                    <td width="6%" rowspan="3" class="title">���ް���Ȳ<br>����:����</td>
                    <td width=4% rowspan="3" class="title">����</td> 
                </tr>
                <tr> 
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=8% rowspan="2" class="title">������</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=8% rowspan="2" class="title">�̻�뿬��<br>�Ҹ꿹����</td>                                  		               
                </tr>
                <tr> 
                    <td width=4% class="title">����</td>
                    <td width=4% class="title">���</td>
                    <td width=4% class="title">�̻��</td>
                    <td width=4% class="title">�̿�</td>
                    <td width=4% class="title">���</td>
                    <td width=4% class="title">�̻��</td>                  
                </tr>
                <tr> 
                    <td align="center"><%= ht.get("BR_NM") %></td>
                    <td align="center"><%= ht.get("DEPT_NM") %></td>
                    <td align="center"><%= ht.get("USER_POS") %></td>
                    <td align="center"><%= ht.get("USER_NM") %>
               <!--        <a href="javascript:MM_openBrWindow('vacation_force_view.jsp?auth_rw=1&user_id=<%= ht.get("USER_ID") %>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=460,height=400,top=50,left=50')"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="�̻�뿬���뺸��������"></a>&nbsp; -->
                    </td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
                    <td align="center"><%= ht.get("YEAR") %></td>
                    <td align="center"><%= ht.get("MONTH") %></td>
                    <td align="center"><%= ht.get("DAY") %></td>
                    <td align="center"><b><%= ht.get("VACATION") %></b></td>
                    <td align="center"><font style="color:red;"><b><%= ht.get("SU") %></b></font></td>
                    <td align="center"><font style="color:blue;"><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) %></b></font></td>
                  
 <% if ( ht.get("YEAR").equals("0")) { %>
 					<td align="center">&nbsp;</td>
 <% } else { %>                   
					<td align="center"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td>       
 <% }  %>                     
					
<% if ( AddUtil.parseInt(String.valueOf(ht.get("D_90_DT")))   <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 		
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("C_DUE_DT")) %></td>	 

<% } else {  %>					
	<% if ( String.valueOf(ht.get("REMAIN")).equals("") || String.valueOf(ht.get("REMAIN")).equals("0") || AddUtil.parseInt(String.valueOf(ht.get("DUE_DT")))  <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 									
			
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
					<td  width=3% align="center">&nbsp;</td>	
   <% } else { %>   
   					<td  width=3% align="right"><%= ht.get("REMAIN") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= ht.get("IWOL_SU") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= AddUtil.parseDouble((String)ht.get("REMAIN"))-AddUtil.parseDouble((String)ht.get("IWOL_SU")) %>&nbsp;</td>	 
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("DUE_DT")) %></td>	 
    <% }  %>  
 <% }  %>
 					<td width=6% align="center">
						<%if(b_su >= 3){%>
						<font color = 'red'><b>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						</font></b>
						<%}else{%>
						<%=AddUtil.parseInt((String)ht3.get("B1"))%> : <%=AddUtil.parseInt((String)ht3.get("B2"))%>
						<%}%>
					</td> 
 					<td width=4% align="center"><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %></td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td></td>
    </tr>
    
    <tr> 
        <td><p>�� ���ǻ���<br>
            1. ������(�ٷα��ع�����) 3���� ���� ������� �����ִ� �̻�� ������ ����ȹ���� �ѹ����� ���� �ٶ��ϴ�.<br>							
            2. ������(�ٷα��ع�����) 2���� ���� ������� ����ȹ���� �������� ���� �̻�� ������ ȸ�簡 ��뿹������ ���Ͽ� �뺸�� �� �ֽ��ϴ�.<br>													

          </p>
        </td>
    </tr>
   
    <tr> 
        <td><font color="#999999">�� ������ �߻� �� �Ҹ��� �Ի����� �������Դϴ�. ���� ���ο� ������ ������ �Ի��Ͽ� ��ӱٹ��Ⱓ�� ���� �����ϼ��� ������ �߻��մϴ�.</font></td>
    </tr>
     
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>������볻��</span></td>
    </tr>
</table>


<table  width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" rowspan=2 width=8%>����</td>
                    <td class="title" width=14%  colspan=2>����</td> <!-- �̿��� �ִ� ��� 30�ϱ��� ���� -->
                    <td class="title" rowspan=2 width=8%>�޿�</td>
                    <td class="title" rowspan=2 width=11%>�������</td>
                    <td class="title" rowspan=2 width=8%>����</td>
                    <td class="title" rowspan=2 width=11%>�������</td>
                    <td class="title" rowspan=2 width=40%>����</td>
                </tr>
                 <tr> 
                    <td class="title" width=7%>�߻�</td>
                    <td class="title" width=7%>���</td>                  
                </tr>
                
                <% if(vt.size()>0){
        			 for(int i=0; i< vt.size(); i++){
        				Hashtable sch = (Hashtable)vt.elementAt(i);	
        			        			        				
        				use_dt= String.valueOf(sch.get("START_YEAR"))+String.valueOf(sch.get("START_MON"))+String.valueOf(sch.get("START_DAY"));
        				        			
        	  %>
                <tr> 
                    <td align="center"><%= i+1 %></td>   
                    <td align="center"><%if( sch.get("IWOL").equals("Y")){%>�̿� <%} else {%>�ű�<%}%></td>  
                    <td align="center">
                    <%if( sch.get("COUNT").equals("B1")){%>���� <%} else if ( sch.get("COUNT").equals("B2")){%>���� <%} else {%>����<%}%> </td>    
                    <td align="center"><%if( sch.get("OV_YN").equals("Y")){%>����<%}else{%>����<%}%></td>
                    <td align="center"><%= AddUtil.ChangeDate2(use_dt) %></td>
                    <td align="center"><%= sch.get("DAY_NM") %></td> 
                    <td align="center"><%= AddUtil.ChangeDate2((String)sch.get("REG_DT")) %></td>
                    <td align="left">&nbsp;<%= sch.get("TITLE") %> - <%= sch.get("CONTENT") %>
                    <% if (ck_acar_id.equals("000063")) { %>
                       <a href="javascript:sch_d( '<%=user_id%>', '<%=sch.get("START_YEAR")%>', '<%=sch.get("START_MON")%>', '<%=sch.get("START_DAY")%>',  '<%=sch.get("SEQ")%>');">D</a>
                    <% }  %>
                    </td>
                </tr>
                <% 	}%>
				
        		  <%}else{ %>
                <tr> 
                    <td colspan="8" align="center">��볻���� �����ϴ�.</td>
                </tr>
                <% } %>
				
            </table>
        </td>
    </tr>
    
	<tr>
        <td>&nbsp;</td>
    </tr>
     
    <tr> 
        <td><div align="left"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ��� ����</span></div></td>
    </tr>
     <tr> 
        <td>
          <p> 1. �����ް� : �ް����� ����<br>
            2. �����ް� : �����ް�(���� ����� ��û�� ��쿡 ����)<br>
            3. �����ް� :<br>
            &nbsp;&nbsp;&nbsp;1) �Ի� 1���� : �ִ� 11�� (����:2017-12-28, ����:2018-05-29)<br>
            &nbsp;&nbsp;&nbsp;2) ���� 1�� ��� �ٷ��� �� : 15��<br>
            &nbsp;&nbsp;&nbsp;3) 3���̻� ��� �ٷ��� �� : ���� 1���� �ʰ��Ͽ� ��� �ٷο���. ��2�⿡ ���Ͽ� 1���� 
            �����Ͽ� ��(25���� �ѵ��� ��)<br>
            &nbsp;&nbsp;&nbsp;4) �ް��� 1�Ⱓ ������� �ƴ��� ������ �Ҹ�Ǹ�, �̻�� �ް��� ���Ͽ��� �������� ����<br>
            &nbsp;&nbsp;&nbsp;5) �ϱ��ް��� �����ް��ϼ��� ������ (��, ���ټӻ�� �����ް� �� ������ �ް��� �������� ����)<br>
             &nbsp;&nbsp;&nbsp;6) �̻�뿬���� �Ҹ���(�ٷα��ع� �ؿ�)���� 30�ϳ� �̿��ؼ� ��밡��(�ٷα��ع��� �系����, ����:2021-12-08)<br>	 						
   			4. ���ް� : (�ٷα��ع��� �系����, ����/����:2021-12-08)<br>
            &nbsp;&nbsp;&nbsp;1) ����.���ĸ� ��Ī�ϸ鼭 ���<br>
            &nbsp;&nbsp;&nbsp;2) ����2ȸ �̻� ����.���ĸ� �����ؼ��� ��� �� ���Ұ�<br>
            &nbsp;&nbsp;&nbsp;3) ���ϱٹ� �߽Ĵ��� 50%�� ����<br>
               
            &nbsp;&nbsp;&nbsp;<!--6) ���ܱ��� : �������� ���� ������ ����(���� �Ի����� ����)�� �߻��� ����(�Ǵ� ��� �� ���� ����)�� �ͳ�(���� �Ի����� ����)���� 1�Ⱓ ������ ������ ����� �� �ִ�.<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (��,�������ް��� �����Ͽ� ���������� ����� ��������� ����) (���� 2016��10��19��) <�������� : 2016���� �ұ�����><br>-->
          </p>
        <!--   <p>&nbsp;&nbsp;<�������� : 2009�� 4�� 17��></p>-->
        </td>
      </tr>
</table>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

</form>
</body>
</html>
