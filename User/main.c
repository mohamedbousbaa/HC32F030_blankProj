/******************************************************************************
* Copyright (C) 2018, Xiaohua Semiconductor Co.,Ltd All rights reserved.
*
* This software is owned and published by:
* Xiaohua Semiconductor Co.,Ltd ("XHSC").
*
* BY DOWNLOADING, INSTALLING OR USING THIS SOFTWARE, YOU AGREE TO BE BOUND
* BY ALL THE TERMS AND CONDITIONS OF THIS AGREEMENT.
*
* This software contains source code for use with XHSC
* components. This software is licensed by XHSC to be adapted only
* for use in systems utilizing XHSC components. XHSC shall not be
* responsible for misuse or illegal use of this software for devices not
* supported herein. XHSC is providing this software "AS IS" and will
* not be responsible for issues arising from incorrect user implementation
* of the software.
*
* Disclaimer:
* XHSC MAKES NO WARRANTY, EXPRESS OR IMPLIED, ARISING BY LAW OR OTHERWISE,
* REGARDING THE SOFTWARE (INCLUDING ANY ACOOMPANYING WRITTEN MATERIALS),
* ITS PERFORMANCE OR SUITABILITY FOR YOUR INTENDED USE, INCLUDING,
* WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, THE IMPLIED
* WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE OR USE, AND THE IMPLIED
* WARRANTY OF NONINFRINGEMENT.
* XHSC SHALL HAVE NO LIABILITY (WHETHER IN CONTRACT, WARRANTY, TORT,
* NEGLIGENCE OR OTHERWISE) FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT
* LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION,
* LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING FROM USE OR
* INABILITY TO USE THE SOFTWARE, INCLUDING, WITHOUT LIMITATION, ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES OR LOSS OF DATA,
* SAVINGS OR PROFITS,
* EVEN IF Disclaimer HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
* YOU ASSUME ALL RESPONSIBILITIES FOR SELECTION OF THE SOFTWARE TO ACHIEVE YOUR
* INTENDED RESULTS, AND FOR THE INSTALLATION OF, USE OF, AND RESULTS OBTAINED
* FROM, THE SOFTWARE.
*
* This software may be replicated in part or whole for the licensed use,
* with the restriction that this Disclaimer and Copyright notice must be
* included with each copy of this software, whether used in part or whole,
* at all times.
*/
/******************************************************************************/
/** \file main.c
 **
 ** A detailed description is available at
 ** @link Sample Group Some description @endlink
 **
 **   - 2018-05-08  1.0  Lux First version for Device Driver Library of Module.
 **
 ******************************************************************************/

/******************************************************************************
 * Include files
 ******************************************************************************/
#include "gpio.h"

/******************************************************************************
 * Local pre-processor symbols/macros ('#define')
 ******************************************************************************/

/******************************************************************************
 * Global variable definitions (declared in header file with 'extern')
 ******************************************************************************/

/******************************************************************************
 * Local type definitions ('typedef')
 ******************************************************************************/

/******************************************************************************
 * Local function prototypes ('static')
 ******************************************************************************/

/******************************************************************************
 * Local variable definitions ('static')                                      *
 ******************************************************************************/

/******************************************************************************
 * Local pre-processor symbols/macros ('#define')
 ******************************************************************************/

/*****************************************************************************
 * Function implementation - global ('extern') and local ('static')
 ******************************************************************************/
static void initialisation(void);
void lcd_init();
void commande(char com[10]);
void affichage(char aff[10]);
void affiche_mots(char mots[20]);
int32_t pins[]={GpioPin0,GpioPin1,GpioPin2,GpioPin3,GpioPin4,GpioPin5,GpioPin6,GpioPin7};

#define RS GpioPin2
#define RW GpioPin1
#define E  GpioPin0
/**
 ******************************************************************************
 ** \brief  Main function of project
 **
 ** \return uint32_t return value, if needed
 **
 ** This sample
 **
 ******************************************************************************/
int main(void)
{
    ///< LED端口初始化
   initialisation();
   
    commande("00111000");
    commande("00001110");
    commande("00000110");
   /*  affichage("01000001");
    affichage("01011001");
    affichage("01101101");
    affichage("01000001");
    affichage("01101110"); */
    affiche_mots("12");
    
 
  
   
    while(1)
    {
            ;
    }
}



static void initialisation(void)
{

    stc_gpio_cfg_t stcGpioCfg;
    stcGpioCfg.enDir = GpioDirOut;

    stcGpioCfg.enPu = GpioPuDisable;
    stcGpioCfg.enPd = GpioPdEnable;

    Sysctrl_SetPeripheralGate(SysctrlPeripheralGpio, TRUE); 

    Gpio_Init(STK_LED_PORT, STK_LED_PIN, &stcGpioCfg);
    Gpio_Init(GpioPortC,RS , &stcGpioCfg);
    Gpio_Init(GpioPortC,RW, &stcGpioCfg);
    Gpio_Init(GpioPortC,E , &stcGpioCfg);
    Gpio_ClrIO(GpioPortC, RW);
    for (int i = 0;i<=7; i++){
        Gpio_Init(GpioPortA,pins[i] , &stcGpioCfg);
    }

}

void commande(char com[10]){
    for (int i=7;i>=0;i--){
        if(com[7-i]=='0'){
             Gpio_ClrIO(GpioPortA, pins[i]);
        }
        if(com[7-i]=='1'){
             Gpio_SetIO(GpioPortA, pins[i]);
        }
    }
    Gpio_ClrIO(GpioPortC, RS);
    Gpio_SetIO(GpioPortC, E);
    delay1ms(10);
    Gpio_ClrIO(GpioPortC, E);


}
void affichage(char aff[10]){
    for (int i=7;i>=0;i--){
        if(aff[7-i]=='0'){
             Gpio_ClrIO(GpioPortA, pins[i]);
        }
        if(aff[7-i]=='1'){
             Gpio_SetIO(GpioPortA, pins[i]);
        }
    }
    Gpio_SetIO(GpioPortC, RS);
    Gpio_SetIO(GpioPortC, E);
    delay1ms(100);
    Gpio_ClrIO(GpioPortC, E);

}

void lcd_init(){
    commande("00000001");
    delay1ms(100);
    commande("00111000");
    delay1ms(100);
    commande("00000110");
    delay1ms(100);
    commande("00001100");
    delay1ms(100);
}

void affiche_mots(char mots[20]){
    for(int i=0 ; strlen(mots);i++){
        switch (mots[i])
        {
        case '0':
            affichage("00110000");
            break;
        case 'P':
             affichage("01010000");
            break;
        case 'p':
             affichage("01110000");
            break;
        case '-':
             affichage("10110000");
            break;
        case '!':
             affichage("00100001");
            break;
        case '1':
             affichage("00110001");
            break;
        case 'A':
             affichage("01000001");
            break;
        case 'Q':
             affichage("01010001");
            break;
        case 'a':
             affichage("01100001");
            break;
        case 'q':
             affichage("01110001");
            break;
        case '"':
             affichage("00100010");
            break;
        case '2':
             affichage("001100100");
            break;
        case 'B':
             affichage("01000010");
            break;
        case 'R':
             affichage("01010010");
            break;
        case 'b':
             affichage("01100010");
            break;
        case 'r':
             affichage("01110010");
            break;
        default:
            break;
        }
    }
}



