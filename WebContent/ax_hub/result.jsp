<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%
    /* ============================================================================== */
    /* =   PAGE : ���� ��� ��� PAGE                                               = */
    /* = -------------------------------------------------------------------------- = */
    /* =   pp_ax_hub.jsp ���Ͽ��� ó���� ������� ����ϴ� �������Դϴ�.            = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ������ ������ �߻��ϴ� ��� �Ʒ��� �ּҷ� �����ϼż� Ȯ���Ͻñ� �ٶ��ϴ�.= */
    /* =   ���� �ּ� : http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */
%>
<%!
    /* ============================================================================== */
    /* =   null ���� ó���ϴ� �޼ҵ�                                                = */
    /* = -------------------------------------------------------------------------- = */
        public String f_get_parm( String val )
        {
          if ( val == null ) val = "";
          return  val;
        }
    /* ============================================================================== */
%>
<%
	request.setCharacterEncoding("euc-kr") ;
    /* ============================================================================== */
    /* =   ���� ���                                                                = */
    /* = -------------------------------------------------------------------------- = */
	String site_cd		= f_get_parm( request.getParameter( "site_cd"	     ) );      // ����Ʈ �ڵ�
    	String req_tx           = f_get_parm( request.getParameter( "req_tx"         ) );      // ��û ����(����/���)
    	String use_pay_method   = f_get_parm( request.getParameter( "use_pay_method" ) );      // ��� ���� ����
    	String bSucc            = f_get_parm( request.getParameter( "bSucc"          ) );      // ��ü DB ����ó�� �Ϸ� ����
    /* = -------------------------------------------------------------------------- = */
    	String res_cd           = f_get_parm( request.getParameter( "res_cd"         ) );      // ��� �ڵ�
    	String res_msg          = f_get_parm( request.getParameter( "res_msg"        ) );      // ��� �޽���
	String res_msg_bsucc    = "";
    /* = -------------------------------------------------------------------------- = */
    	String ordr_idxx        = f_get_parm( request.getParameter( "ordr_idxx"      ) );      // �ֹ���ȣ
    	String tno              = f_get_parm( request.getParameter( "tno"            ) );      // KCP �ŷ���ȣ
    	String good_mny         = f_get_parm( request.getParameter( "good_mny"       ) );      // ���� �ݾ�
    	String good_name        = f_get_parm( request.getParameter( "good_name"      ) );      // ��ǰ��
    	String buyr_name        = f_get_parm( request.getParameter( "buyr_name"      ) );      // �����ڸ�
    	String buyr_tel1        = f_get_parm( request.getParameter( "buyr_tel1"      ) );      // ������ ��ȭ��ȣ
    	String buyr_tel2        = f_get_parm( request.getParameter( "buyr_tel2"      ) );      // ������ �޴�����ȣ
    	String buyr_mail        = f_get_parm( request.getParameter( "buyr_mail"      ) );      // ������ E-Mail
    /* = -------------------------------------------------------------------------- = */
	// ����
	String pnt_issue        = f_get_parm( request.getParameter( "pnt_issue"      ) );      // ����Ʈ ���񽺻�
    	String app_time         = f_get_parm( request.getParameter( "app_time"       ) );      // ���νð� (����)
    /* = -------------------------------------------------------------------------- = */
    	// �ſ�ī��
    	String card_cd          = f_get_parm( request.getParameter( "card_cd"        ) );      // ī�� �ڵ�
    	String card_name        = f_get_parm( request.getParameter( "card_name"      ) );      // ī���
	String noinf		= f_get_parm( request.getParameter( "noinf"	     ) );      // ������ ����
    	String quota            = f_get_parm( request.getParameter( "quota"          ) );      // �Һΰ���
	String app_no           = f_get_parm( request.getParameter( "app_no"         ) );      // ���ι�ȣ
    /* = -------------------------------------------------------------------------- = */
    	// ������ü
    	String bank_name        = f_get_parm( request.getParameter( "bank_name"      ) );      // �����
	String bank_code        = f_get_parm( request.getParameter( "bank_code"      ) );      // �����ڵ�
    /* = -------------------------------------------------------------------------- = */
    	// �������
    	String bankname         = f_get_parm( request.getParameter( "bankname"       ) );      // �Ա��� ����
    	String depositor        = f_get_parm( request.getParameter( "depositor"      ) );      // �Ա��� ���� ������
   	String account          = f_get_parm( request.getParameter( "account"        ) );      // �Ա��� ���� ��ȣ
    	String va_date          = f_get_parm( request.getParameter( "va_date"        ) );      // ������� �Աݸ����ð�
    /* = -------------------------------------------------------------------------- = */
    	// ����Ʈ
    	String pt_idno		= f_get_parm( request.getParameter( "pt_idno"	     ) );      // ���� �� ���� ���̵�
	String add_pnt          = f_get_parm( request.getParameter( "add_pnt"        ) );      // �߻� ����Ʈ
    	String use_pnt          = f_get_parm( request.getParameter( "use_pnt"        ) );      // ��밡�� ����Ʈ
    	String rsv_pnt          = f_get_parm( request.getParameter( "rsv_pnt"        ) );      // ���� ����Ʈ
    	String pnt_app_time     = f_get_parm( request.getParameter( "pnt_app_time"   ) );      // ���νð�
    	String pnt_app_no       = f_get_parm( request.getParameter( "pnt_app_no"     ) );      // ���ι�ȣ
    	String pnt_amount       = f_get_parm( request.getParameter( "pnt_amount"     ) );      // �����ݾ� or ���ݾ�
    /* = -------------------------------------------------------------------------- = */
	//�޴���
	String commid		= f_get_parm( request.getParameter( "commid"	     ) );      // ��Ż� �ڵ�
	String mobile_no	= f_get_parm( request.getParameter( "mobile_no"      ) );      // �޴��� ��ȣ
    /* = -------------------------------------------------------------------------- = */
	//��ǰ��
	String tk_van_code      = f_get_parm( request.getParameter( "tk_van_code"    ) );      // �߱޻� �ڵ�
	String tk_app_no        = f_get_parm( request.getParameter( "tk_app_no"      ) );      // ���� ��ȣ
    /* = -------------------------------------------------------------------------- = */
    	// ���ݿ�����
    	String cash_yn          = f_get_parm( request.getParameter( "cash_yn"        ) );      // ���� ������ ��� ����
    	String cash_authno      = f_get_parm( request.getParameter( "cash_authno"    ) );      // ���� ������ ���� ��ȣ
    	String cash_tr_code     = f_get_parm( request.getParameter( "cash_tr_code"   ) );      // ���� ������ ���� ����
    	String cash_id_info     = f_get_parm( request.getParameter( "cash_id_info"   ) );      // ���� ������ ��� ��ȣ
    /* = -------------------------------------------------------------------------- = */
    	// �Ƹ���ī
    	String am_ax_code       = f_get_parm( request.getParameter( "am_ax_code"        ) );      // �Ƹ���ī ������ȣ
    /* ============================================================================== */

    	String req_tx_name = "";

    	if     ( req_tx.equals( "pay" ) ) 
	{ 
		req_tx_name = "����" ;
	}
    	else if( req_tx.equals( "mod" ) )
	{ 
		req_tx_name = "���/����" ;
	}

    /* ============================================================================== */
    /* =   ������ �� DB ó�� ���н� �� ��� �޽��� ����                           = */
    /* = -------------------------------------------------------------------------- = */

    	if ( "pay".equals ( req_tx ) )
    	{
        	// ��ü DB ó�� ����
        	if ( "false".equals ( bSucc ) )
        	{
            		if ( "0000".equals ( res_cd ) )
			{
                		res_msg_bsucc = "������ ���������� �̷�������� ���θ����� ���� ����� ó���ϴ� �� ������ �߻��Ͽ� �ý��ۿ��� �ڵ����� ��� ��û�� �Ͽ����ϴ�. <br> ���θ��� ��ȭ�Ͽ� Ȯ���Ͻñ� �ٶ��ϴ�." ;
			}
            		else
			{
				res_msg_bsucc = "������ ���������� �̷�������� ���θ����� ���� ����� ó���ϴ� �� ������ �߻��Ͽ� �ý��ۿ��� �ڵ����� ��� ��û�� �Ͽ�����, <br> <b>��Ұ� ���� �Ǿ����ϴ�.</b><br> ���θ��� ��ȭ�Ͽ� Ȯ���Ͻñ� �ٶ��ϴ�." ;
			}
		}
    	}

    /* = -------------------------------------------------------------------------- = */
    /* =   ������ �� DB ó�� ���н� �� ��� �޽��� ���� ��                        = */
    /* ============================================================================== */

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head>
    <title>*** Amazoncar ***</title>
    <link href="css/sample.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="Javascript">
<!--
var isNS = (navigator.appName == "Netscape") ? 1 : 0;
var EnableRightClick = 0;
if(isNS) 
document.captureEvents(Event.MOUSEDOWN||Event.MOUSEUP);

function mischandler(){
  if(EnableRightClick==1){ return true; }
  else {return false; }
}

function mousehandler(e){
  if(EnableRightClick==1){ return true; }
  var myevent = (isNS) ? e : event;
  var eventbutton = (isNS) ? myevent.which : myevent.button;
  if((eventbutton==2)||(eventbutton==3)) return false;
}

function keyhandler(e) {
  var myevent = (isNS) ? e : window.event;
  if (myevent.keyCode==96)
    EnableRightClick = 1;
  return;
}

document.oncontextmenu = mischandler;
document.onkeypress = keyhandler;
document.onmousedown = mousehandler;
document.onmouseup = mousehandler;
//-->
</script>    
    <script type="text/javascript">
    
        /* �ſ�ī�� ������ ���� ��ũ��Ʈ */
        function receiptView(tno)
        {
            receiptWin = "https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no=" + tno ;
            window.open(receiptWin , "" , "width=470, height=815") ;
        }

	/* ���ݿ����� ���� ��ũ��Ʈ */
        function receiptView2( site_cd, order_id, bill_yn, auth_no )
        {
        	receiptWin2 = "https://admin.kcp.co.kr/Modules/Service/Cash/Cash_Bill_Common_View.jsp";
        	receiptWin2 += "?";
        	receiptWin2 += "term_id=PGNW" + site_cd + "&";
        	receiptWin2 += "orderid=" + order_id + "&";
        	receiptWin2 += "bill_yn=" + bill_yn + "&";
        	receiptWin2 += "authno=" + auth_no ;

        	window.open(receiptWin2 , "" , "width=360, height=645");
        }
    </script>
</head>



<body>
<div align="center">
    <table width="589" cellspacing="0" cellpadding="0">
        <tr>
	        <td height=5></td>
		</tr>
		<tr>
	     	<td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=img/logo_acc.gif></td>
		</tr>
		<tr>
			<td height=6></td>
		</tr>
        <tr>
			<td>
				<table width=589 cellspacing=0 cellpadding=0 border=0  background=img/acc_ask_bg.gif>
					<tr>
						<td><img src=img/acc_rst_top.gif></td>
					</tr>
					<tr>
						<td height=15></td>
					</tr>
					<!--
                    <tr style="height:17px">
                        <td style="background-image:url('./img/ttbg551.gif');border:0px " class="white">
                            <span class="bold big">[������]</span> �� �������� ���� ����� ����ϴ� ����(����) �������Դϴ�.
                        </td>
                    </tr>
                    <tr>
                        <td style="background-image:url('./img/boxbg551.gif') ;text-align:left;" >
                            ��û ����� ����ϴ� ������ �Դϴ�.<br/>
                            ��û�� ���������� ó���� ��� ����ڵ�(res_cd)���� 0000���� ǥ�õ˴ϴ�.
                        </td>
                    </tr>
                    <tr style="height:11px"><td style="background:url('./img/boxbtm551.gif') no-repeat;"></td></tr>-->
<%
    /* ============================================================================== */
    /* =   ���� ��� �ڵ� �� �޽��� ���(����������� �ݵ�� ������ֽñ� �ٶ��ϴ�.)= */
    /* = -------------------------------------------------------------------------- = */
    /* =   ���� ���� : res_cd���� 0000���� �����˴ϴ�.                              = */
    /* =   ���� ���� : res_cd���� 0000�̿��� ������ �����˴ϴ�.                     = */
    /* = -------------------------------------------------------------------------- = */
%>
					<tr> 
     					<td align=center>         
							<table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_20">
							    <tr><td colspan="2"  class="title"><img src=img/acc_rst_bar1.gif></td></tr>
							    <!-- ��� �ڵ� 
					                    <tr><td class="sub_title1">��� �ڵ�</td><td class="sub_content1 bold"><%=res_cd%></td></tr>-->
					                    <!-- ��� �޽��� -->
					                    <tr><td class="sub_title1">��� �޼���</td><td class="sub_content1 bold"><%=res_msg%></td></tr>
					<%
					    	// ó�� ������(pp_ax_hub.jsp)���� ������ DBó�� �۾��� ������ ��� �󼼸޽����� ����մϴ�.
					    	if( !"".equals ( res_msg_bsucc ) )
					    	{
					%>
					                    <tr><td class="sub_title1">��� �� �޼���</td><td><%=res_msg_bsucc%></td></tr>
							</table>
						</td>
					</tr>
                	<tr>
                		<td align=center>

<%
    	}
%>
<%
    /* = -------------------------------------------------------------------------- = */
    /* =   ���� ��� �ڵ� �� �޽��� ��� ��                                         = */
    /* ============================================================================== */
%>

<%
    /* ============================================================================== */
    /* =   01. ���� ��� ���                                                       = */
    /* = -------------------------------------------------------------------------- = */
    	if ( "pay".equals ( req_tx ) )
    	{
        	/* ============================================================================== */
        	/* =   01-1. ��ü DB ó�� ����(bSucc���� false�� �ƴ� ���)                     = */
        	/* = -------------------------------------------------------------------------- = */
        	if ( ! "false".equals ( bSucc ) )
        	{
            		/* ============================================================================== */
            		/* =   01-1-1. ���� ������ ���� ��� ��� ( res_cd���� 0000�� ���)             = */
            		/* = -------------------------------------------------------------------------- = */
            		if ( "0000".equals ( res_cd ) )
            		{
%>
							<table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_10">
			                    <tr><td colspan="2" class="title"><img src=img/acc_rst_bar2.gif></td></tr>
			                     <!-- �ֹ���ȣ -->
			                     <tr><td class="sub_title1">�ֹ� ��ȣ</td><td class="sub_content1"><%= ordr_idxx %></td></tr>
			                     <!-- KCP �ŷ���ȣ 
			                     <tr><td class="sub_title1">KCP �ŷ���ȣ</td><td class="sub_content1"><%= tno %></td></tr>-->
			                     <!-- �����ݾ� -->
			                     <tr><td class="sub_title1">���� �ݾ�</td><td class="sub_content1"><%= good_mny %>��</td></tr>
			                     <!-- ��ǰ��(good_name) -->
			                     <tr><td class="sub_title1">��ǰ��</td><td class="sub_content1"><%= good_name %></td></tr>
			                     <!-- �ֹ��ڸ� -->
			                     <tr><td class="sub_title1">�ֹ��ڸ�</td><td class="sub_content1"><%= buyr_name %></td></tr>
			                     <!-- �ֹ��� ��ȭ��ȣ -->
			                     <tr><td class="sub_title1">�ֹ��� ��ȭ��ȣ</td><td class="sub_content1"><%= buyr_tel1 %></td></tr>
			                     <!-- �ֹ��� �޴�����ȣ -->
			                     <tr><td class="sub_title1">�ֹ��� �޴�����ȣ</td><td class="sub_content1"><%= buyr_tel2 %></td></tr>
			                     <!-- �ֹ��� E-mail -->
			                     <tr><td class="sub_title1">�ֹ��� E-mail</td><td class="sub_content1"><%= buyr_mail %></td></tr>
			                 </table>
			        	</td>
					</tr>
                	<tr>
                		<td align=center>
<%
                		/* ============================================================================== */
                		/* =   �ſ�ī�� ���� ��� ���                                             = */
                		/* = -------------------------------------------------------------------------- = */
                		if ( use_pay_method.equals("100000000000") )
                		{
%>
							<table width="85%" align="center" border="0" cellpadding="0" cellspacing="1" class="margin_top_20">
							    <tr><td colspan="2" class="title"><img src=img/acc_rst_bar3.gif></td></tr>
					                    <!-- �������� : �ſ�ī�� -->
					         	<!--<tr><td class="sub_title1">���� ����</td><td class="sub_content1">�ſ�ī��</td></tr>-->
					                    <!-- ���� ī�� -->
					       		<tr><td class="sub_title1">���� ī��</td><td class="sub_content1"><%//=card_cd%><%=card_name%></td></tr>
					                    <!-- ���νð� 
					        	<tr><td class="sub_title1">���� �ð�</td><td class="sub_content1"><%=app_time%></td></tr>-->
					                    <!-- ���ι�ȣ 
					          	<tr><td class="sub_title1">���� ��ȣ</td><td class="sub_content1"><%=app_no%></td></tr>-->
					                    <!-- �Һΰ��� -->
					    		<tr><td class="sub_title1">�Һ� ����</td><td class="sub_content1"><%if(quota.equals("00")){%>�Ͻú�<%}else{%><%=quota%><%}%></td></tr>
					                    <!-- ������ ���� 
					         	<tr><td class="sub_title1">������ ����</td><td class="sub_content1"><%=noinf%></td></tr>-->
			                	<tr><td class="sub_title1">������ Ȯ��</td><td class="sub_content1"><a href="javascript:receiptView('<%=tno%>')"><img src="img/acc_btn_rcp.gif" alt="�������� Ȯ���մϴ�." /></td></tr>
			                    
			                    
			                </table>
			       		</td>
					</tr>
					
                	<tr>
                		<td align=center>
<%					}%>

<%
            		}
            		/* = -------------------------------------------------------------------------- = */
            		/* =   01-1-1. ���� ������ ���� ��� ��� END                                   = */
            		/* ============================================================================== */
        	}
        	/* = -------------------------------------------------------------------------- = */
        	/* =   01-1. ��ü DB ó�� ���� END                                              = */
        	/* ============================================================================== */
    	}
    	/* = -------------------------------------------------------------------------- = */
    	/* =   01. ���� ��� ��� END                                                   = */
    	/* ============================================================================== */
%>
			                <table width="100%" class="margin_top_10"  background=img/acc_ask_bg.gif>
			                    <tr><td style="text-align:center">
			                            <!--<a href="index.html"><img src="./img/btn_home.gif" width="108" height="37" alt="ó������ �̵��մϴ�" /></a>-->
			                            <a href="javascript:window.close()"><img src="img/acc_btn_cls.gif" alt="�������� �ݽ��ϴ�." /></a>
			                    </td></tr>
			                </table>
			         	</td>
					</tr>
				</table>
            </td>
        </tr>
        <tr><td><img src=img/acc_ask_btm.gif></td></tr>
    </table>
    </div>
</body>
</html>

