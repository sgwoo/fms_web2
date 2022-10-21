<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.insur.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" 		scope="page"/>

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase i_db = InsDatabase.getInstance();
	
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String com_emp_yn = request.getParameter("com_emp_yn")==null?"":request.getParameter("com_emp_yn");
	
	Vector client_vt = new Vector();

	client_vt = i_db.getIjwListmailing2(client_id, car_mng_id, com_emp_yn);		
	
	int client_vt_size = client_vt.size();		
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	
	
	for(int k=0;k<1;k++){							
		Hashtable ht = (Hashtable)client_vt.elementAt(k);
		//�߽��� ����� ���� ��ȸ
		user_bean 	= umd.getUsersBean(String.valueOf(ht.get("BUS_ID2")));
		user_id = user_bean.getUser_id();
	}
	
	String insmng_id = nm_db.getWorkAuthUser("�λ꺸����");
	
	UsersBean insmng_bean 	= umd.getUsersBean(insmng_id);
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>���� ���� �ڵ��� ���� ���� ��û��</title>
<style type="text/css">
<!--
.style1 {color: #373737}
.style2 {color: #333333; line-height:19px;}
.style3 {color: #ff8004}
.style4 {color: #a74073; font-weight: bold;font-size:14px;}
.style5 {color: #c39235}
.style6 {color: #8b8063;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
body{
font-family:nanumgothic
}


-->
</style>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>

<script language="JavaScript">
<!--	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
</head>
<body topmargin=0 leftmargin=0>
<table width=740 border=0 cellspacing=0 cellpadding=0 align=center   
	style="border: 1px solid lightgreen;
	border-radius: 1em; border-top-left-radius: 1em;
	border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
	border-bottom-right-radius: 1em;">
    <tr>
        <td height=20></td>
    </tr>
    <tr>
<!--         <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file3.jpg></td> -->
<!--         <td><img src=https://fms5.amazoncar.co.kr/mailing/ins/images/layout_top_ins_file4.gif style="width:100%;"></td> -->
        <td style="font-family:nanumgothic;font-size:17px;">&nbsp;&nbsp;&nbsp;<b>�������� �ڵ������� ���� ��û��</b></td>
       
    </tr>
     <tr>
        <td height=20></td>
    </tr>
<!--     <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr> -->
    <tr>
        <td align=center>
            <table width=676 border=0 cellspacing=0 cellpadding=0 >
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=500 height=35 align="left" style="font-family:nanumgothic;font-size:12px;"><b><%=client.getFirm_nm()%> </b>��</td>
                    <td width=60 align="center">
                    <div    style="font-family:nanumgothic;font-size:10px; 
                    		background-color:lightblue; height: 12px; padding-top: 2px;
                    		border-radius: 1em; border-top-left-radius: 1em;
							border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
							border-bottom-right-radius: 1em;"">
                     <b>�����</b></div></td>
                    <td width=221 align="left" style="font-family:nanumgothic;font-size:12px;">&nbsp;&nbsp;<%if(user_bean.getUser_nm().equals("�ǿ�ö")){%>���缮<%}else{%><%=user_bean.getUser_nm()%><%}%>&nbsp;&nbsp;<%=user_bean.getUser_m_tel()%> </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=center background="">
            <table width=676 border=0 cellspacing=0 cellpadding=0 
            style="background-color: aliceblue;
            border-radius: 1em; border-top-left-radius: 1em;
			border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
			border-bottom-right-radius: 1em;"
            ">
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td width=20>&nbsp;</td>
                    <td width=670 align=center>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>

                            <tr>
                                <td height=10></td>
                            </tr>
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">
                            	<span>�ҵ漼�� ����� �����������Ͽ� ���λ���� �� �Ʒ��� �ش��ϴ� ����</span>
                            	<b>���������ڵ������迡 ����</b>�Ͽ��� �մϴ�. 
                            	<div>
                            	<br/>
                            	<span>- ��� : ���ǽŰ�Ȯ�δ����, ����������(*) �����</span><br/>
								&nbsp;<span>* ���������� : �Ƿ��, ���Ǿ�, ���� �� ���ΰ���ġ���� ����ɡ� ��109����2����7ȣ�� ���� ����� �����ϴ� ����� (��ȣ���, ȸ����, �������, ������� ��)</span>
								<br/> <br/>
								- �������� : <b>����ں� 1��� ���������ڵ������� ���Դ�󿡼� ����, 1�븦 ������ ������ ���� ���������ڵ������� �̰��� �� ����� 50%�� ����</b><br/>
								<br/>
								<span>- ����ñ� : 2021�� 1�� 1�� ���� ������¿��� ���� ���� �к��� ����</span><br/>
								<br/>
                            	</div>
                            	<span>�ڼ��� ������ ÷������(������¿��� �պ�ó�� ���� �ȳ�(2020-02-03)_���λ����.pdf)�� �����Ͻñ� �ٶ��ϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                           
                            <tr>
                            	<td style="font-family:nanumgothic;font-size:13px;">�ش��ü�� �Ʒ� <span style="color: #a74073; font-weight: bold;font-size:14px;">[���������ڵ������� ���� ��û��]</span>�� �ۼ��Ͻþ� <b>2021�� 1�� 1�� �������� �Ƹ���ī<br>
                            	(FAX. <%=user_bean.getI_fax()%>)
                            	<%if(user_bean.getI_fax().equals("")){%><%=insmng_bean.getI_fax()%>)<%}%>
                            	</b>�� �����ֽñ� �ٶ��ϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                            <tr>
                                <td height=18 align="left" style="font-family:nanumgothic;font-size:13px;">�Ƹ���ī�� �̿��� �ּż� �������� ����帮��, �ñ��Ͻ� ������ �����ø� ����ڿ��� ��ȭ�ֽñ� �ٶ��ϴ�.</td>
                            </tr>
                        </table>
                    </td>
                    <td width=20>&nbsp;</td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
                <tr>
                    <td colspan=3></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td height=30 align=center ></td>
    </tr>
    <tr>
        <td align=center>
            <table width=656 border=0 cellspacing=0 cellpadding=0>
                
                <tr>
                    <td height=20></td>
                </tr>
                <tr>
                    <td align="left">
                    <div 
                    style="width:120px;height:22px;padding-top:5px;margin-left:15px;
                    		text-align:center;
                    		font-size:12px;background-color:slategray;color:white; 
                    		border-radius: 1em; border-top-left-radius: 1em;
							border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
							border-bottom-right-radius: 1em;">
                    		<b>���踸�⸮��Ʈ</b></div></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td align=center>
                        <table width=690 border=0 cellspacing=1 cellpadding=0 bgcolor=d6d6d6>
	                        <tr>
	                        	<td height=2 bgcolor=656e7f colspan=4></td>
	                        </tr>
                            <tr>
                                <td bgcolor=f2f2f2 height=40 width=15% align=center style="font-family:nanumgothic;font-size:12px;">���� ����<br>������</td>
                                <td bgcolor=f2f2f2 width=35% align=center style="font-family:nanumgothic;font-size:12px;">����</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">������ȣ</td>
                                <td bgcolor=f2f2f2 width=25% align=center style="font-family:nanumgothic;font-size:12px;">���� ���뺸��<br>���Դ������ ����</td>
                            </tr>
                			<%														
							for(int k=0;k<client_vt_size;k++){
							
        							  Hashtable ht = (Hashtable)client_vt.elementAt(k);
        							          						  
 					%>
        						 <tr bgcolor=#ffffff>
        						 		<td height=40 align=center style="font-family:nanumgothic;font-size:12px;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INS_EXP_DT")))%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;color:#a74073;"><%=ht.get("CAR_NO")%></td>
												<td align=center style="font-family:nanumgothic;font-size:12px;"><%=ht.get("COM_EMP_YN")%></td>
										 </tr>
										<% }%>                            
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                	<td style="font-family:nanumgothic;font-size:12px;">&nbsp;�� ����ں� 1��� ���������ڵ������� ���Դ�󿡼� ����, 1�븦 ������ ������ ���� ���������ڵ������� �̰��� �� ����� <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50%�� �����˴ϴ�.</span></td>
                </tr>
                <tr>
                    <td height=35></td>
                </tr>
                <tr>
                	<td align=center><a href=http://fms1.amazoncar.co.kr/fms2/lc_rent/task_doc_ins.jsp?id1=<%=client_id%>&id2=<%=user_id%>&id3=<%=car_mng_id%>&id4=<%=com_emp_yn%>  target="_blank" style="text-decoration: none;">
						<div class="radius-border" 
						style="background-color:mediumvioletred;color:white;height:28px;width:320px; 
						padding-top:7px; box-shadow: 0px 4px 6px 0px grey;
						border-radius: 1em; border-top-left-radius: 1em;
						border-top-right-radius: 1em; border-bottom-left-radius: 1em; 
						border-bottom-right-radius: 1em;
						">
						<b>�������� �ڵ������� ���Կ�û��</b></div>
                	</a></td>
                </tr>
                 
                <tr>
                    <td height=20></td>
                </tr>

				<tr>
					<td height=30></td>
				</tr>                
            </table>
        </td>
    </tr>
    
<!--     <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif<img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr> -->
  <!--   <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr> -->
    <!-- <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=85><img src=http://fms1.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=493><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr> -->
  <!--   <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr> -->
</table>
</body>
</html>